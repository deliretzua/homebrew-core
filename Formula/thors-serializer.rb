class ThorsSerializer < Formula
  desc "Declarative serialization library (JSON/YAML) for C++"
  homepage "https://github.com/Loki-Astari/ThorsSerializer"
  url "https://github.com/Loki-Astari/ThorsSerializer.git",
      tag:      "2.2.21",
      revision: "9021e52ed02b5a7fd41c4a53ab7ebf5e54a675ec"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "633263fecd1ea5221d9c308648c37ff7ccfdb5706aea75f229aaa1f269a0f4d6"
    sha256 cellar: :any,                 arm64_monterey: "db5c2d068ad11a3c2b8fbbff7a9f0aa235259c54168c27d7b5ad2ed86e94bbf2"
    sha256 cellar: :any,                 arm64_big_sur:  "9ec757797de7c096a29139694cd3b418447616584c3565ad7a287660fe5ef30a"
    sha256 cellar: :any,                 ventura:        "e327a03ac571522fa8c4c1f08c16918792c1ba4f1bf43c4c19b69993babaecc6"
    sha256 cellar: :any,                 monterey:       "7b3abd9b17cfb029eb91a5a72138d80a459683acffd9947a3eda0a4a60143c91"
    sha256 cellar: :any,                 big_sur:        "f8e4983ac22ba370bce29903a6b7c429f7a0b815abe0db669584a2b229aafd73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21c0509cd17aa40295cdbd05f4996f257b7e0c128e1dfedd86e921738d194834"
  end

  depends_on "boost" => :build
  depends_on "bzip2"
  depends_on "libyaml"
  depends_on "magic_enum"

  fails_with gcc: "5"

  def install
    ENV["COV"] = "gcov"

    system "./configure", "--disable-vera",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "ThorSerialize/JsonThor.h"
      #include "ThorSerialize/SerUtil.h"
      #include <sstream>
      #include <iostream>
      #include <string>

      struct HomeBrewBlock
      {
          std::string             key;
          int                     code;
      };
      ThorsAnvil_MakeTrait(HomeBrewBlock, key, code);

      int main()
      {
          using ThorsAnvil::Serialize::jsonImporter;
          using ThorsAnvil::Serialize::jsonExporter;

          std::stringstream   inputData(R"({"key":"XYZ","code":37373})");

          HomeBrewBlock    object;
          inputData >> jsonImporter(object);

          if (object.key != "XYZ" || object.code != 37373) {
              std::cerr << "Fail";
              return 1;
          }
          std::cerr << "OK";
          return 0;
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test",
           "-I#{Formula["boost"].opt_include}",
           "-I#{include}", "-L#{lib}", "-lThorSerialize17", "-lThorsLogging17", "-ldl"
    system "./test"
  end
end
