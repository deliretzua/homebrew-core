class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https://sysdig.com/"
  license "Apache-2.0"
  revision 4

  stable do
    url "https://github.com/draios/sysdig/archive/refs/tags/0.31.5.tar.gz"
    sha256 "9af98cae7c38273f7429ba0df628c9745bd92c949f444e180b9dd800af14c6dd"

    # Update to value of FALCOSECURITY_LIBS_VERSION found in
    # https://github.com/draios/sysdig/blob/#{version}/cmake/modules/falcosecurity-libs.cmake
    resource "falcosecurity-libs" do
      url "https://github.com/falcosecurity/libs/archive/refs/tags/0.10.5.tar.gz"
      sha256 "2a4b37c08bec4ba81326314831f341385aff267062e8d4483437958689662936"

      # Fix 'file INSTALL cannot make directory "/sysdig/userspace/libscap"'.
      # Reported upstream at https://github.com/falcosecurity/libs/issues/995.
      # Remove when `falcosecurity-libs` is upgraded to 0.11.0 or newer.
      patch do
        url "https://github.com/falcosecurity/libs/commit/73020ac4fdd1ba84b53f431e1c069049828480e9.patch?full_index=1"
        sha256 "97fde5e4aa8e20e91ffaaca4020b7a38751d1ad95d69db02bf10c82588c6595b"
      end
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_ventura:  "2ab22b7020fb6e667474b3ff229ac1ef9bd22993eb286871f8e10b3a84747ae4"
    sha256                               arm64_monterey: "0aeb537f8135b101176e6478a4663cce26081cb8ae78f430e85b5074a36c0763"
    sha256                               arm64_big_sur:  "262e1bebdc76010ed84855b412427c17ee573a0b82a0b442f3771f8667a16bb1"
    sha256                               ventura:        "e6df97587cb20bd689d35e20269f04068325d077d9412b42bc4ccd16b649ed75"
    sha256                               monterey:       "ff308857d7d4973c659bd6a4de137ce20a4648ab3ab1b9e5e68c8d3ff6b03051"
    sha256                               big_sur:        "d0ee0324e212204cee4dfd4826a9e984ae7e88493dc56fb281179390c7ec0ca8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5fcd55190487e5cbe0fcee0b5b56415edbec888d2d5088bda5a3417937dcdf4"
  end

  head do
    url "https://github.com/draios/sysdig.git", branch: "dev"

    resource "falcosecurity-libs" do
      url "https://github.com/falcosecurity/libs.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "valijson" => :build
  depends_on "c-ares"
  depends_on "jsoncpp"
  depends_on "luajit"
  depends_on "re2"
  depends_on "tbb"
  depends_on "yaml-cpp"

  uses_from_macos "curl"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libb64" => :build
    depends_on "abseil"
    depends_on "elfutils"
    depends_on "grpc@1.54"
    depends_on "jq"
    depends_on "openssl@3"
    depends_on "protobuf@21"
  end

  fails_with gcc: "5" # C++17

  # More info on https://gist.github.com/juniorz/9986999
  resource "homebrew-sample_file" do
    url "https://gist.githubusercontent.com/juniorz/9986999/raw/a3556d7e93fa890a157a33f4233efaf8f5e01a6f/sample.scap"
    sha256 "efe287e651a3deea5e87418d39e0fe1e9dc55c6886af4e952468cd64182ee7ef"
  end

  def install
    (buildpath/"falcosecurity-libs").install resource("falcosecurity-libs")

    # FIXME: Workaround Apple ARM loader error due to packing.
    # ld: warning: pointer not aligned at address 0x10017E21D
    #   (_g_event_info + 527453 from ../../libscap/libscap.a(event_table.c.o))
    # ld: unaligned pointer(s) for architecture arm64
    inreplace "falcosecurity-libs/driver/ppm_events_public.h", " __attribute__((packed))", "" if Hardware::CPU.arm?

    # Override hardcoded C++ standard settings.
    inreplace %w[CMakeLists.txt falcosecurity-libs/cmake/modules/CompilerFlags.cmake],
              /set\(CMAKE_CXX_FLAGS "(.*) -std=c\+\+0x"\)/,
              'set(CMAKE_CXX_FLAGS "\\1")'

    # Keep C++ standard in sync with `abseil.rb`.
    args = %W[
      -DSYSDIG_VERSION=#{version}
      -DUSE_BUNDLED_DEPS=OFF
      -DCREATE_TEST_TARGETS=OFF
      -DBUILD_LIBSCAP_EXAMPLES=OFF
      -DDIR_ETC=#{etc}
      -DFALCOSECURITY_LIBS_SOURCE_DIR=#{buildpath}/falcosecurity-libs
      -DCMAKE_CXX_FLAGS=-std=c++17
    ]

    # `USE_BUNDLED_*=OFF` flags are implied by `USE_BUNDLED_DEPS=OFF`, but let's be explicit.
    %w[CARES JSONCPP LUAJIT OPENSSL RE2 TBB VALIJSON CURL NCURSES ZLIB B64 GRPC JQ PROTOBUF].each do |dep|
      args << "-DUSE_BUNDLED_#{dep}=OFF"
    end

    args << "-DBUILD_DRIVER=OFF" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (pkgshare/"demos").install resource("homebrew-sample_file").files("sample.scap")
  end

  test do
    output = shell_output("#{bin}/sysdig -r #{pkgshare}/demos/sample.scap")
    assert_match "/tmp/sysdig/sample", output
  end
end
