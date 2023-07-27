class Envoy < Formula
  desc "Cloud-native high-performance edge/middle/service proxy"
  homepage "https://www.envoyproxy.io/index.html"
  url "https://github.com/envoyproxy/envoy/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "143a433817b38dee5474a500816e26f38e7f4d1375162ad2d889918273be146b"
  license "Apache-2.0"
  head "https://github.com/envoyproxy/envoy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30b234294134bf7d9ca6bb1dbe57abaf66438cf434df586649e3e1abc0939d52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "909dabadae3638cf566f1aa37900eb42a28fa649b4e95ecbc3c487b2701102a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94f402e725cc319061fdb4522653dc71a6de22435c806bf9c5a9cdd6c1a792ce"
    sha256 cellar: :any_skip_relocation, ventura:        "e3978e8ce1047138edcf7f5267e7741cb1a1c7ed894851f5dd6de94962730cdd"
    sha256 cellar: :any_skip_relocation, monterey:       "522f68ac2e42f52eaa0523522f2bd5344795beb42adfddfcd5d3c305f6a733bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "47989780111c3c6a953815adeb5949caada8a65463c02d07c4a580be53d72cb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b4eb77de3c27dfa10f83c76ba739d0bf87c9adfa222a8ce2ed4e45cd9a49ccc"
  end

  depends_on "automake" => :build
  depends_on "bazelisk" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "ninja" => :build
  # Starting with 1.21, envoy requires a full Xcode installation, not just
  # command-line tools. See envoyproxy/envoy#16482
  depends_on xcode: :build
  depends_on macos: :catalina

  uses_from_macos "python" => :build

  on_macos do
    depends_on "coreutils" => :build
  end

  # https://github.com/envoyproxy/envoy/tree/main/bazel#supported-compiler-versions
  fails_with :gcc do
    version "8"
    cause "C++17 support and tcmalloc requirement"
  end

  def install
    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s

    env_path = "#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin"
    args = %W[
      --compilation_mode=opt
      --curses=no
      --verbose_failures
      --action_env=PATH=#{env_path}
      --host_action_env=PATH=#{env_path}
    ]

    if OS.linux?
      # Build fails with GCC 10+ at external/com_google_absl/absl/container/internal/inlined_vector.h:448:5:
      # error: '<anonymous>.absl::inlined_vector_internal::Storage<char, 128, std::allocator<char> >::data_'
      # is used uninitialized in this function [-Werror=uninitialized]
      # Try to remove in a release that uses a newer abseil
      args << "--cxxopt=-Wno-uninitialized"
      args << "--host_cxxopt=-Wno-uninitialized"
    else
      # The clang available on macOS catalina has a warning that isn't clean on v8 code.
      # The warning doesn't show up with more recent clangs, so disable it for now.
      args << "--cxxopt=-Wno-range-loop-analysis"
      args << "--host_cxxopt=-Wno-range-loop-analysis"

      # To suppress warning on deprecated declaration on v8 code. For example:
      # external/v8/src/base/platform/platform-darwin.cc:56:22: 'getsectdatafromheader_64'
      # is deprecated: first deprecated in macOS 13.0.
      # https://bugs.chromium.org/p/v8/issues/detail?id=13428.
      # Reference: https://github.com/envoyproxy/envoy/pull/23707.
      args << "--cxxopt=-Wno-deprecated-declarations"
      args << "--host_cxxopt=-Wno-deprecated-declarations"
    end

    # Write the current version SOURCE_VERSION.
    system "python3", "tools/github/write_current_source_version.py", "--skip_error_in_git"

    system Formula["bazelisk"].opt_bin/"bazelisk", "build", *args, "//source/exe:envoy-static.stripped"
    bin.install "bazel-bin/source/exe/envoy-static.stripped" => "envoy"
    pkgshare.install "configs", "examples"
  end

  test do
    port = free_port

    cp pkgshare/"configs/envoyproxy_io_proxy.yaml", testpath/"envoy.yaml"
    inreplace "envoy.yaml" do |s|
      s.gsub! "port_value: 9901", "port_value: #{port}"
      s.gsub! "port_value: 10000", "port_value: #{free_port}"
    end

    fork do
      exec bin/"envoy", "-c", "envoy.yaml"
    end
    sleep 10
    assert_match "HEALTHY", shell_output("curl -s 127.0.0.1:#{port}/clusters?format=json")
  end
end
