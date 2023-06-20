class Libzip < Formula
  desc "C library for reading, creating, and modifying zip archives"
  homepage "https://libzip.org/"
  url "https://libzip.org/download/libzip-1.9.2.tar.xz", using: :homebrew_curl
  sha256 "c93e9852b7b2dc931197831438fee5295976ee0ba24f8524a8907be5c2ba5937"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url "https://libzip.org/download/"
    regex(/href=.*?libzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8de8fe253e24ec75c12d517bc250adbc1eee57c552294328b949125f4d0c7b5f"
    sha256 cellar: :any,                 arm64_monterey: "7a966f01601a53d9ccc549cb810b185e1390ae00373ef8826f2583d30dfe9c4f"
    sha256 cellar: :any,                 arm64_big_sur:  "24a1f8456561b5e6610042805f66e1223ad1349fced70f6a1894ecedd417829f"
    sha256 cellar: :any,                 ventura:        "adcf6e82477325feab6ff98d302f70394c6b259060799da4fdd141ad043feb76"
    sha256 cellar: :any,                 monterey:       "e3629ae190b59c78c2a4d7e5fc752bb9fa592cf076c140aa4cc6a7e5e17ccf67"
    sha256 cellar: :any,                 big_sur:        "46ddd547972bc0d1bdd1b15c9abd4e92f78e5aeb813675a50e5cc8d23dc8e7e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c908f3c4b683f2c34da76472624397829c3953e9041693c18d08152096db84e"
  end

  depends_on "cmake" => :build
  depends_on "zstd"

  uses_from_macos "zip" => :test
  uses_from_macos "bzip2"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  conflicts_with "libtcod", "minizip-ng",
    because: "libtcod, libzip and minizip-ng install a `zip.h` header"

  def install
    crypto_args = %w[
      -DENABLE_GNUTLS=OFF
      -DENABLE_MBEDTLS=OFF
    ]
    crypto_args << "-DENABLE_OPENSSL=OFF" if OS.mac? # Use CommonCrypto instead.
    system "cmake", ".", *std_cmake_args,
                         *crypto_args,
                         "-DBUILD_REGRESS=OFF",
                         "-DBUILD_EXAMPLES=OFF"
    system "make", "install"
  end

  test do
    touch "file1"
    system "zip", "file1.zip", "file1"
    touch "file2"
    system "zip", "file2.zip", "file1", "file2"
    assert_match(/\+.*file2/, shell_output("#{bin}/zipcmp -v file1.zip file2.zip", 1))
  end
end
