class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  license :cannot_represent
  head "https://code.qt.io/qbs/qbs.git", branch: "master"

  stable do
    url "https://download.qt.io/official_releases/qbs/1.22.0/qbs-src-1.22.0.tar.gz"
    sha256 "ebfd4b4f115f7ad235477ddf74cc7216dfa66b6166372dc0be454691078f9f3e"

    # Fix Xcode support for 13.3. Remove in the next release.
    patch do
      url "https://code.qt.io/cgit/qbs/qbs.git/patch/?id=d64c7802fef2872aa6a78c06648a0aed45250955"
      sha256 "cccc3fc3a00ddd71e12ad7f89d4e391c476b537719ba904a3afc42e658df4313"
    end
  end

  livecheck do
    url "https://download.qt.io/official_releases/qbs/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "0667091084114e97fd64090afb76d75e4a716ea2b2ba6777a5889c8e0382d8aa"
    sha256 cellar: :any, arm64_big_sur:  "900f49365a295c6d73beee3950610d84abdbc557ca249e463949acbba7f03f0f"
    sha256 cellar: :any, monterey:       "e08c756d201e8887c326bbc2bba403aa7c7e98356f9fc95cb1a61467b4af26e3"
    sha256 cellar: :any, big_sur:        "09680c8b5b4f0f13182342f82d43f298751e14923f5b712efe950f036565d3ec"
    sha256 cellar: :any, catalina:       "c131f0df2958f8e33e907830973fce8f0870ac8ea9ee7749604cbf39f27ff516"
  end

  depends_on "cmake" => :build
  depends_on "qt@5"

  def install
    qt5 = Formula["qt@5"].opt_prefix
    system "cmake", ".", "-DQt5_DIR=#{qt5}/lib/cmake/Qt5", "-DQBS_ENABLE_RPATH=NO",
                         *std_cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", "."
  end

  test do
    (testpath/"test.c").write <<~EOS
      int main() {
        return 0;
      }
    EOS

    (testpath/"test.qbs").write <<~EOS
      import qbs

      CppApplication {
        name: "test"
        files: ["test.c"]
        consoleApplication: true
      }
    EOS

    system "#{bin}/qbs", "run", "-f", "test.qbs"
  end
end
