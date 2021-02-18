class Libiodbc < Formula
  desc "Database connectivity layer based on ODBC. (alternative to unixodbc)"
  homepage "http://www.iodbc.org/dataspace/iodbc/wiki/iODBC/"
  url "https://github.com/openlink/iODBC/archive/v3.52.14.tar.gz"
  sha256 "896d7e16b283cf9a6f5b5f46e8e9549aef21a11935726b0170987cd4c59d16db"
  license any_of: ["BSD-3-Clause", "LGPL-2.0-only"]

  bottle do
    sha256 cellar: :any, arm64_big_sur: "35bf9aab3420bf0ba56bfa8802fe1274d397e3a74783f8d1c7c1cb769e3ad83c"
    sha256 cellar: :any, big_sur:       "5788f536c0ccce81f9205bc8950d9c158299a3f2339f546192fa695313eb88a7"
    sha256 cellar: :any, catalina:      "b9b78f823c2af7962bfc97cb34fd528c8f6eab85823045168ac8ac84eaac3d12"
    sha256 cellar: :any, mojave:        "1472bb0987705537158b7c3196d27d01ba02d6c0fdcca733f3cf8d53eca29c5d"
    sha256 cellar: :any, high_sierra:   "77a4fb5fa3036a831e05e2a83585ac2fcdcdf4cf83baa72f28cfb2f8a659ba13"
    sha256 cellar: :any, sierra:        "abc07f2fe98ed04c4dc5bd5cada2ea68fb9be56337ed442393609f0a22ec21e8"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  conflicts_with "unixodbc", because: "both install `odbcinst.h`"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"iodbc-config", "--version"
  end
end
