class QtLibiodbc < Formula
  desc "Qt SQL Database Driver"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.0/6.0.2/submodules/qtbase-everywhere-src-6.0.2.tar.xz"
  sha256 "991a0e4e123104e76563067fcfa58602050c03aba8c8bb0c6198347c707817f1"
  license all_of: ["GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]

  bottle do
    sha256 cellar: :any, arm64_big_sur: "732b22f49ca9dac967f1bf392d3d01b74502f7d69c4161b56b9269297a8dbdfc"
    sha256 cellar: :any, big_sur:       "b0c24f96f9269bc37d82ac94f619004743600cbc2eba4bd0aacccd040b2eadff"
    sha256 cellar: :any, catalina:      "ca34f6affc55e44180857cee79d645093917642de656ed9b1166aeec0f26ff52"
    sha256 cellar: :any, mojave:        "b673626a451b02fc8ae47b11c4812dea2756ddac7511741467dcafe03979670a"
  end

  depends_on "cmake" => [:build, :test]

  depends_on "libiodbc"
  depends_on "qt"

  conflicts_with "qt-unixodbc",
    because: "qt-unixodbc and qt-libiodbc install the same binaries"

  def install
    cd "src/plugins/sqldrivers" do
      system "qmake", "--", "ODBC_PREFIX=#{Formula["libiodbc"].opt_prefix}"
      system "make", "sub-odbc"
      (share/"qt").install "plugins/"
    end
    Pathname.glob(share/"qt/plugins/sqldrivers/#{shared_library("*")}") do |plugin|
      system "strip", "-S", "-x", plugin
    end
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.19.0)
      project(test VERSION 1.0.0 LANGUAGES CXX)
      set(CMAKE_CXX_STANDARD 17)
      set(CMAKE_CXX_STANDARD_REQUIRED ON)
      set(CMAKE_AUTOMOC ON)
      set(CMAKE_AUTORCC ON)
      set(CMAKE_AUTOUIC ON)
      find_package(Qt6 COMPONENTS Core Sql REQUIRED)
      add_executable(test
          main.cpp
      )
      target_link_libraries(test PRIVATE Qt6::Core Qt6::Sql)
    EOS

    (testpath/"test.pro").write <<~EOS
      QT       += core sql
      QT       -= gui
      TARGET = test
      CONFIG   += console debug
      CONFIG   -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    EOS

    (testpath/"main.cpp").write <<~EOS
      #include <QCoreApplication>
      #include <QtSql>
      #include <cassert>
      int main(int argc, char *argv[])
      {
        QCoreApplication a(argc, argv);
        QSqlDatabase db = QSqlDatabase::addDatabase("QODBC");
        assert(db.isValid());
        return 0;
      }
    EOS

    system "cmake", "-DCMAKE_BUILD_TYPE=Debug", testpath
    system "make"
    system "./test"

    ENV.delete "CPATH"
    system "qmake"
    system "make"
    system "./test"
  end
end
