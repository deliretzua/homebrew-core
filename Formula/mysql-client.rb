class MysqlClient < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/8.0/en/"
  url "https://cdn.mysql.com/Downloads/MySQL-8.0/mysql-boost-8.0.33.tar.gz"
  sha256 "ae31e6368617776b43c82436c3736900067fada1289032f3ac3392f7380bcb58"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    formula "mysql"
  end

  bottle do
    sha256 arm64_ventura:  "95dfb958dd64fddd166ad43e8be6694b9078a2482131bf8598ce567ddb558c6c"
    sha256 arm64_monterey: "42ad933ea6281a8753b2f8b5208c69a8a2a15d1515a9826ce5f58c2c941ecbfd"
    sha256 arm64_big_sur:  "25065dec8c335290a2102d3e33356105ab43ddb150fd0d3ca43df8458e6dde9a"
    sha256 ventura:        "a774309a32f2487174cc87ef78322bc3a38b210b2a225c158afee78b65ba59a5"
    sha256 monterey:       "f59757d710beb675217579a01893ea58f6b41cc3b6af22367c34520f1683c695"
    sha256 big_sur:        "87e9fd2c04fd42dc66382281a8b7ad2ad17a0ce691e4dee8d9e5c7b9eb8af2cd"
    sha256 x86_64_linux:   "1bacf303dc7b4a7f14c6076466546acb5fd3bd118e20bcb2d9d2f7ee3b5673da"
  end

  keg_only "it conflicts with mysql (which contains client libraries)"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "libfido2"
  # GCC is not supported either, so exclude for El Capitan.
  depends_on macos: :sierra if DevelopmentTools.clang_build_version < 900
  depends_on "openssl@1.1"
  depends_on "zlib" # Zlib 1.2.12+
  depends_on "zstd"

  uses_from_macos "libedit"

  fails_with gcc: "5"

  # Fix for "Cannot find system zlib libraries" even though they are installed.
  # https://bugs.mysql.com/bug.php?id=110745
  patch :DATA

  def install
    # -DINSTALL_* are relative to `CMAKE_INSTALL_PREFIX` (`prefix`)
    args = %W[
      -DFORCE_INSOURCE_BUILD=1
      -DCOMPILATION_COMMENT=Homebrew
      -DDEFAULT_CHARSET=utf8mb4
      -DDEFAULT_COLLATION=utf8mb4_general_ci
      -DINSTALL_DOCDIR=share/doc/#{name}
      -DINSTALL_INCLUDEDIR=include/mysql
      -DINSTALL_INFODIR=share/info
      -DINSTALL_MANDIR=share/man
      -DINSTALL_MYSQLSHAREDIR=share/mysql
      -DWITH_BOOST=boost
      -DWITH_EDITLINE=system
      -DWITH_FIDO=system
      -DWITH_LIBEVENT=system
      -DWITH_ZLIB=system
      -DWITH_ZSTD=system
      -DWITH_SSL=yes
      -DWITH_UNIT_TESTS=OFF
      -DWITHOUT_SERVER=ON
    ]

    system "cmake", ".", *std_cmake_args, *args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mysql --version")
  end
end

__END__
diff --git a/cmake/zlib.cmake b/cmake/zlib.cmake
index 460d87a..36fbd60 100644
--- a/cmake/zlib.cmake
+++ b/cmake/zlib.cmake
@@ -50,7 +50,7 @@ FUNCTION(FIND_ZLIB_VERSION ZLIB_INCLUDE_DIR)
   MESSAGE(STATUS "ZLIB_INCLUDE_DIR ${ZLIB_INCLUDE_DIR}")
 ENDFUNCTION(FIND_ZLIB_VERSION)
 
-FUNCTION(FIND_SYSTEM_ZLIB)
+MACRO(FIND_SYSTEM_ZLIB)
   FIND_PACKAGE(ZLIB)
   IF(ZLIB_FOUND)
     ADD_LIBRARY(zlib_interface INTERFACE)
@@ -61,7 +61,7 @@ FUNCTION(FIND_SYSTEM_ZLIB)
         ${ZLIB_INCLUDE_DIR})
     ENDIF()
   ENDIF()
-ENDFUNCTION(FIND_SYSTEM_ZLIB)
+ENDMACRO(FIND_SYSTEM_ZLIB)
 
 MACRO (RESET_ZLIB_VARIABLES)
   # Reset whatever FIND_PACKAGE may have left behind.
