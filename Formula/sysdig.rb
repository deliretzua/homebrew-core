class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https://sysdig.com/"
  url "https://github.com/draios/sysdig/archive/0.27.1.tar.gz"
  sha256 "b9d05854493d245a7a7e75f77fc654508f720aab5e5e8a3a932bd8eb54e49bda"
  license "Apache-2.0"
  revision 5

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               monterey:     "1c21cb89e495b3ec32b67d1082306f3b6ceab5044a7bb01a084a9a702057dbbf"
    sha256                               big_sur:      "fb21720e4d98e4731abd04f9aedd4fdef0b636a4cdb8c2bf033e34936b10d63e"
    sha256                               catalina:     "b5a26be92f10f45b3dc619aab11ac393c2fc8a1a11ab611490921295a6e72d3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ee80f58a6c9138c496e90fb912f174e32b1b5ee617faef52343ff6992d82e5a5"
  end

  depends_on "cmake" => :build
  depends_on "c-ares"
  depends_on "jsoncpp"
  depends_on "luajit"
  depends_on "openssl@1.1"
  depends_on "tbb"

  uses_from_macos "curl"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "elfutils"
    depends_on "gcc"
    depends_on "grpc"
    depends_on "jq"
    depends_on "libb64"
    depends_on "protobuf"
  end

  fails_with gcc: "5" # C++17

  # More info on https://gist.github.com/juniorz/9986999
  resource "sample_file" do
    url "https://gist.githubusercontent.com/juniorz/9986999/raw/a3556d7e93fa890a157a33f4233efaf8f5e01a6f/sample.scap"
    sha256 "efe287e651a3deea5e87418d39e0fe1e9dc55c6886af4e952468cd64182ee7ef"
  end

  # Fix build with GRPC 1.41. Reported upstream at:
  # https://github.com/draios/sysdig/issues/1778
  patch do
    url "https://raw.githubusercontent.com/archlinux/svntogit-community/d0e6e96ed2f95336d1f75266fcf896034268abe4/trunk/0.27.1-grpc-absl-sync.patch"
    sha256 "9390c4c2d8aef6110aae63835aab07585bbe9856c820020750e0ba678e4da653"
  end

  def install
    args = std_cmake_args + %W[
      -DSYSDIG_VERSION=#{version}
      -DUSE_BUNDLED_DEPS=OFF
      -DCREATE_TEST_TARGETS=OFF
      -DBUILD_LIBSCAP_EXAMPLES=OFF
      -DDIR_ETC=#{etc}
    ]

    # `USE_BUNDLED_*=OFF` flags are implied by `USE_BUNDLED_DEPS=OFF`, but let's be explicit.
    %w[LUAJIT JSONCPP ZLIB TBB JQ NCURSES B64 OPENSSL CURL CARES PROTOBUF GRPC].each do |dep|
      args << "-DUSE_BUNDLED_#{dep}=OFF"
    end

    args << "-DBUILD_DRIVER=OFF" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (pkgshare/"demos").install resource("sample_file").files("sample.scap")
  end

  test do
    output = shell_output("#{bin}/sysdig -r #{pkgshare}/demos/sample.scap")
    assert_match "/tmp/sysdig/sample", output
  end
end
