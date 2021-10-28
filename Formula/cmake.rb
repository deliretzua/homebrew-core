class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.21.4/cmake-3.21.4.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.21.4.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.21.4.tar.gz"
  sha256 "d9570a95c215f4c9886dd0f0564ca4ef8d18c30750f157238ea12669c2985978"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3868f3c5fc69d40799447ecf9ce3742288987101e51c7c70307bc8c88aac5c6a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43dcb467effe26a5cca419080e9fded311ecc5badc8339e10fa5b11215131128"
    sha256 cellar: :any_skip_relocation, monterey:       "66b833031cc98c87d3749e610427686f6f9742a7587cbfdcef038ec8b5182bbc"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9f106823e83911365f96a5f1b4cab26649840f06e1cbc541335143b7e71b237"
    sha256 cellar: :any_skip_relocation, catalina:       "1ab2ae431b90878839404643b926eb81e5b6563d2b59cb860a1ebb03d90a09b7"
    sha256 cellar: :any_skip_relocation, mojave:         "da00844fd5e38040486e1e65c415e92eeab82fcf358d5fe97deceffabc48df80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c63d100ea6c854bc764581e622f547bec44e20fc143ed3c5749f73aeb723a3e"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@1.1"
  end

  # The completions were removed because of problems with system bash

  # The `with-qt` GUI option was removed due to circular dependencies if
  # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
  # For the GUI application please instead use `brew install --cask cmake`.

  def install
    args = %W[
      --prefix=#{prefix}
      --no-system-libs
      --parallel=#{ENV.make_jobs}
      --datadir=/share/cmake
      --docdir=/share/doc/cmake
      --mandir=/share/man
    ]
    if OS.mac?
      args += %w[
        --system-zlib
        --system-bzip2
        --system-curl
      ]
    end

    system "./bootstrap", *args, "--", *std_cmake_args,
                                       "-DCMake_INSTALL_EMACS_DIR=#{elisp}",
                                       "-DCMake_BUILD_LTO=ON"
    system "make"
    system "make", "install"

    # Remove deprecated and unusable binary
    # https://gitlab.kitware.com/cmake/cmake/-/issues/20235
    (pkgshare/"Modules/Internal/CPack/CPack.OSXScriptLauncher.in").unlink
  end

  def caveats
    <<~EOS
      To install the CMake documentation, run:
        brew install cmake-docs
    EOS
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."

    # These should be supplied in a separate cmake-docs formula.
    refute_path_exists doc/"html"
    refute_path_exists man
  end
end
