class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "https://pqxx.org/development/libpqxx/"
  # remove autoreconf setup in next release
  url "https://github.com/jtv/libpqxx/archive/7.8.0.tar.gz"
  sha256 "bc471d8d34588f820f38e19e1cc217f399212eef900416cf12f90fab293628af"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "11a89d08364bbe60b61875e4130eb7506b1dc6a607c757b7ecb9958c9321d0d7"
    sha256 cellar: :any,                 arm64_monterey: "02e3154d3969f68f60c391f5665e26555c1219aac09181f4f3e2196d5bdb31f5"
    sha256 cellar: :any,                 arm64_big_sur:  "439caa115a18279d5bc3246415c0e1f3fefcd5b9e1552ffe0c4528742c6d3434"
    sha256 cellar: :any,                 ventura:        "b3fa5df4c2fbedebc3b56e1379d39a6916a1a588387eeb536257cb54f59f6e6b"
    sha256 cellar: :any,                 monterey:       "8772d16243dc809a33a80c9a7f575c0455811c0a43d1a5917a4f7947a4ac6e60"
    sha256 cellar: :any,                 big_sur:        "8ecc0a102b2025bd5df425081ef06427dccc1b8525c1b28ee65853f6e0976822"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f1da92ca90d9087a6161e7d5a3b3a6db481fb5217947f09ce1e962fcd40c9b2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "xmlto" => :build
  depends_on "libpq"
  depends_on macos: :catalina # requires std::filesystem

  fails_with gcc: "5" # for C++17

  def install
    ENV.append "CXXFLAGS", "-std=c++17"
    ENV.prepend_path "PATH", Formula["python@3.11"].opt_libexec/"bin"
    ENV["PG_CONFIG"] = Formula["libpq"].opt_bin/"pg_config"

    # regenerate configure script
    # upstream build patch, https://github.com/jtv/libpqxx/commit/5934bbd, remove in next release
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--prefix=#{prefix}", "--enable-shared"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <pqxx/pqxx>
      int main(int argc, char** argv) {
        pqxx::connection con;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lpqxx",
           "-I#{include}", "-o", "test"
    # Running ./test will fail because there is no running postgresql server
    # system "./test"
  end
end
