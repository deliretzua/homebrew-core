class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.26.2/cmake-3.26.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.26.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.26.2.tar.gz"
  sha256 "d54f25707300064308ef01d4d21b0f98f508f52dda5d527d882b9d88379f89a8"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1c7add2f05290393345cca175a85c9a0390d92b9c05c2a9f20c8df609971da5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2a8ee7ce8329d1a6301b0b8b0354474e8414d2ec68a75d74fb59a6c613dfb9b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5fc868c79f779794f4d61cfabc47862202e52efb0d6526d0ef1bf5a8b5f5e642"
    sha256 cellar: :any_skip_relocation, ventura:        "cafae4b5997b8e937cf26379bb1e8dab1f1a7d9d319afe47bc0ab01e049cc1ff"
    sha256 cellar: :any_skip_relocation, monterey:       "98c3087e47aaf9868308669e51c6fbf3ba413d65a61b9f3c33c95d6474718e17"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e2df9119b8df3a5ef56227ac0b025047194dfe6b89952f6b7f9911514fa4f57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "460af683247b19a036cd803f12e4232b2fe97c2aa6cf37c01203034252d4e79f"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@3"
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
                                       "-DCMake_INSTALL_BASH_COMP_DIR=#{bash_completion}",
                                       "-DCMake_INSTALL_EMACS_DIR=#{elisp}",
                                       "-DCMake_BUILD_LTO=ON"
    system "make"
    system "make", "install"
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
