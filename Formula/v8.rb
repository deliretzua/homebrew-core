class V8 < Formula
  desc "Google's JavaScript engine"
  homepage "https://github.com/v8/v8/wiki"
  # Track V8 version from Chrome stable: https://omahaproxy.appspot.com
  url "https://github.com/v8/v8/archive/9.2.230.20.tar.gz"
  sha256 "9a7203406549e05238fbae1b7541c167a54ea3c077dbfab31c5d21764ec946ec"
  license "BSD-3-Clause"

  livecheck do
    url "https://omahaproxy.appspot.com/all.json?os=mac&channel=stable"
    regex(/"v8_version": "v?(\d+(?:\.\d+)+)"/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c3ebf90ac04f59ff6b8d61302cb1f185f7f36abfde1f412e50778fe73a646a9f"
    sha256 cellar: :any, big_sur:       "84c1685bdb40ac5c9e6776aa508acb8277b3f24780903c0b8ad5149461c25b94"
    sha256 cellar: :any, catalina:      "8bc5408f927f27cb14f06a98cd008ddb631934a936173c45c7e7e837b63c34b9"
    sha256 cellar: :any, mojave:        "e624c7696f994d9f538da54be2f3ef3b78ceda13f420e78bd86b6bde196c82e7"
  end

  depends_on "llvm" => :build
  depends_on "ninja" => :build
  depends_on "python@3.9" => :build

  depends_on xcode: ["10.0", :build] # required by v8

  # Look up the correct resource revisions in the DEP file of the specific releases tag
  # e.g. for CIPD dependency gn: https://github.com/v8/v8/blob/9.1.269.28/DEPS#L50
  resource "gn" do
    url "https://gn.googlesource.com/gn.git",
        revision: "39a87c0b36310bdf06b692c098f199a0d97fc810"
  end

  # e.g.: https://github.com/v8/v8/blob/9.1.269.28/DEPS#L91 for the revision of build for v8 9.1.269.28
  resource "v8/build" do
    url "https://chromium.googlesource.com/chromium/src/build.git",
        revision: "4036cf1b17581f5668b487a25e252d56e0321a7f"
  end

  resource "v8/third_party/icu" do
    url "https://chromium.googlesource.com/chromium/deps/icu.git",
        revision: "f022e298b4f4a782486bb6d5ce6589c998b51fe2"
  end

  resource "v8/base/trace_event/common" do
    url "https://chromium.googlesource.com/chromium/src/base/trace_event/common.git",
        revision: "d5bb24e5d9802c8c917fcaa4375d5239a586c168"
  end

  resource "v8/third_party/googletest/src" do
    url "https://chromium.googlesource.com/external/github.com/google/googletest.git",
        revision: "23ef29555ef4789f555f1ba8c51b4c52975f0907"
  end

  resource "v8/third_party/jinja2" do
    url "https://chromium.googlesource.com/chromium/src/third_party/jinja2.git",
        revision: "11b6b3e5971d760bd2d310f77643f55a818a6d25"
  end

  resource "v8/third_party/markupsafe" do
    url "https://chromium.googlesource.com/chromium/src/third_party/markupsafe.git",
        revision: "0944e71f4b2cb9a871bcbe353f95e889b64a611a"
  end

  resource "v8/third_party/zlib" do
    url "https://chromium.googlesource.com/chromium/src/third_party/zlib.git",
        revision: "5b8d433953beb2a75a755ba321a3076b95f7cdb9"
  end

  def install
    (buildpath/"build").install resource("v8/build")
    (buildpath/"third_party/jinja2").install resource("v8/third_party/jinja2")
    (buildpath/"third_party/markupsafe").install resource("v8/third_party/markupsafe")
    (buildpath/"third_party/googletest/src").install resource("v8/third_party/googletest/src")
    (buildpath/"base/trace_event/common").install resource("v8/base/trace_event/common")
    (buildpath/"third_party/icu").install resource("v8/third_party/icu")
    (buildpath/"third_party/zlib").install resource("v8/third_party/zlib")

    # Build gn from source and add it to the PATH
    (buildpath/"gn").install resource("gn")
    cd "gn" do
      system "python3", "build/gen.py"
      system "ninja", "-C", "out/", "gn"
    end
    ENV.prepend_path "PATH", buildpath/"gn/out"

    # create gclient_args.gni
    (buildpath/"build/config/gclient_args.gni").write <<~EOS
      declare_args() {
        checkout_google_benchmark = false
      }
    EOS

    # setup gn args
    gn_args = {
      is_debug:                     false,
      is_component_build:           true,
      v8_use_external_startup_data: false,
      v8_enable_i18n_support:       true, # enables i18n support with icu
      clang_base_path:              "\"#{Formula["llvm"].opt_prefix}\"", # uses Homebrew clang instead of Google clang
      clang_use_chrome_plugins:     false, # disable the usage of Google's custom clang plugins
      use_custom_libcxx:            false, # uses system libc++ instead of Google's custom one
      treat_warnings_as_errors:     false, # ignore not yet supported clang argument warnings
    }

    # use clang from homebrew llvm formula, because the system clang is unreliable
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib # but link against system libc++

    # Transform to args string
    gn_args_string = gn_args.map { |k, v| "#{k}=#{v}" }.join(" ")

    # Build with gn + ninja
    system "gn", "gen", "--args=#{gn_args_string}", "out.gn"
    system "ninja", "-j", ENV.make_jobs, "-C", "out.gn", "-v", "d8"

    # Install all the things
    (libexec/"include").install Dir["include/*"]
    libexec.install Dir["out.gn/lib*.dylib", "out.gn/d8", "out.gn/icudtl.dat"]
    bin.write_exec_script libexec/"d8"
  end

  test do
    assert_equal "Hello World!", shell_output("#{bin}/d8 -e 'print(\"Hello World!\");'").chomp
    t = "#{bin}/d8 -e 'print(new Intl.DateTimeFormat(\"en-US\").format(new Date(\"2012-12-20T03:00:00\")));'"
    assert_match %r{12/\d{2}/2012}, shell_output(t).chomp

    (testpath/"test.cpp").write <<~EOS
      #include <libplatform/libplatform.h>
      #include <v8.h>
      int main(){
        static std::unique_ptr<v8::Platform> platform = v8::platform::NewDefaultPlatform();
        v8::V8::InitializePlatform(platform.get());
        v8::V8::Initialize();
        return 0;
      }
    EOS

    # link against installed libc++
    system ENV.cxx, "-std=c++14", "test.cpp",
      "-I#{libexec}/include",
      "-L#{libexec}", "-lv8", "-lv8_libplatform"
  end
end
