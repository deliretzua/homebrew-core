class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.20.2/cmake-3.20.2.tar.gz"
  sha256 "aecf6ecb975179eb3bb6a4a50cae192d41e92b9372b02300f9e8f1d5f559544e"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ba0636abd0f4699b19f86bb0aa7ced422bf47e341f48fc7fb9363e7bd0985ad7"
    sha256 cellar: :any_skip_relocation, big_sur:       "dd3bad404e54c2066d947d409f72adb8b53ac9eeb58565480c194add9088aa12"
    sha256 cellar: :any_skip_relocation, catalina:      "97703b1bf9ee5368c970eb72774b751cce23c23900c994f1fbdc3b27019115ee"
    sha256 cellar: :any_skip_relocation, mojave:        "b3ba0a1115ea579e7b83ed54509c07cbefb0934085515726a00539ff626e1ee2"
  end

  depends_on "sphinx-doc" => :build

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@1.1"
  end

  patch do
    url "https://github.com/Kitware/CMake/commit/fa8599e9a6297585513e9849f5ce086b81f42eb0.patch?full_index=1"
    sha256 "d867b95fc6c9fe185f0fbd3f66fb74c09605d8896a52eafc9c9af0ffe13c3f70"
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
      --sphinx-build=#{Formula["sphinx-doc"].opt_bin}/sphinx-build
      --sphinx-html
      --sphinx-man
    ]
    on_macos do
      args += %w[
        --system-zlib
        --system-bzip2
        --system-curl
      ]
    end

    system "./bootstrap", *args, "--", *std_cmake_args,
                                       "-DCMake_INSTALL_EMACS_DIR=#{elisp}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."
  end
end
