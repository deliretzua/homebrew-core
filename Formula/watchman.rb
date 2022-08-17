class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  license "MIT"

  stable do
    url "https://github.com/facebook/watchman/archive/v2022.08.15.00.tar.gz"
    sha256 "8b95b0ac3de81bd7bc7d243e4785d4e9f8e8c41d70a0fb8b03425c078bdcc434"

    resource "edencommon" do
      url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2022.08.15.00.tar.gz"
      sha256 "5e04fc7a0577160f5736a411097086bd85eeef5066f44387b00305b107b0563a"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "69775dc8dd522c9502e7b926e836ba16587af63c9a6e898654ebe436c47893c6"
    sha256 cellar: :any, arm64_big_sur:  "c164b725b60192b690dc1e93f886f2f9f13fd5f689e11ca805ae56f13777f018"
    sha256 cellar: :any, monterey:       "f4d609e3001b05d72c6e5a43a8cddea60c4a1360b8d7ce61800bf5b0741ae862"
    sha256 cellar: :any, big_sur:        "b08f98f2a8edcfb2e21341919131000dc67ad8fe9d0b8cd5cc6365676e125233"
    sha256 cellar: :any, catalina:       "c5d30d8080fce4eec117424b9ee2acab0c3f54bfb47ae87449ec584d77a6e757"
    sha256               x86_64_linux:   "d42035a075968a15daa9ed8c6aa8c93ece0f108cd1d45259f04f552a54bab094"
  end

  # https://github.com/facebook/watchman/issues/963
  pour_bottle? only_if: :default_prefix

  head do
    url "https://github.com/facebook/watchman.git", branch: "main"

    resource "edencommon" do
      url "https://github.com/facebookexperimental/edencommon.git", branch: "main"
    end
  end

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
  depends_on "googletest" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "boost"
  depends_on "fb303"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "openssl@1.1"
  depends_on "pcre2"
  depends_on "python@3.10"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    resource("edencommon").stage do
      system "cmake", "-S", ".", "-B", "_build",
                      *std_cmake_args(install_prefix: buildpath/"edencommon")
      system "cmake", "--build", "_build"
      system "cmake", "--install", "_build"
    end

    # Fix build failure on Linux. Borrowed from Fedora:
    # https://src.fedoraproject.org/rpms/watchman/blob/rawhide/f/watchman.spec#_70
    inreplace "CMakeLists.txt", /^t_test/, "#t_test" if OS.linux?

    # NOTE: Setting `BUILD_SHARED_LIBS=ON` will generate DSOs for Eden libraries.
    #       These libraries are not part of any install targets and have the wrong
    #       RPATHs configured, so will need to be installed and relocated manually
    #       if they are built as shared libraries. They're not used by any other
    #       formulae, so let's link them statically instead. This is done by default.
    system "cmake", "-S", ".", "-B", "build",
                    "-Dedencommon_DIR=#{buildpath}/edencommon/lib/cmake/edencommon",
                    "-DENABLE_EDEN_SUPPORT=ON",
                    "-DWATCHMAN_VERSION_OVERRIDE=#{version}",
                    "-DWATCHMAN_BUILDINFO_OVERRIDE=#{tap.user}",
                    "-DWATCHMAN_STATE_DIR=#{var}/run/watchman",
                    *std_cmake_args

    # Workaround for `Process terminated due to timeout`
    ENV.deparallelize { system "cmake", "--build", "build" }
    system "cmake", "--install", "build"

    path = Pathname.new(File.join(prefix, HOMEBREW_PREFIX))
    bin.install (path/"bin").children
    lib.install (path/"lib").children
    path.rmtree
  end

  def post_install
    (var/"run/watchman").mkpath
    chmod 042777, var/"run/watchman"
  end

  test do
    assert_equal(version.to_s, shell_output("#{bin}/watchman -v").chomp)
  end
end
