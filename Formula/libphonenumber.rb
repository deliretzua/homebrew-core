class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.13.6.tar.gz"
  sha256 "5c27ee33739981f87d77d1525a59a1358aebea045fea8cc00540662fcae8f62c"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "15c2c6302f7a5c179fc906d2f625e573331d9d2c96fe544ead4de99276cdc487"
    sha256 cellar: :any,                 arm64_monterey: "86c5414a82fae92ac1703d756003bf176d039af082962b74ca7aede13979d77e"
    sha256 cellar: :any,                 arm64_big_sur:  "d7c6b6d82ed28c27ac29cda7f1730004874fde86dab9bf93c8307f2a1f24bb3e"
    sha256 cellar: :any,                 ventura:        "5d64ff54ab92ee3ea76f319f3b0ec15ef99c87e4fba1d184e7a917891a78f87c"
    sha256 cellar: :any,                 monterey:       "e0f9c847a98b7f3fc3fb69ada1171bf81773aadc2045d8e44eed7ed178276385"
    sha256 cellar: :any,                 big_sur:        "e005fae2ff7f8e012bd7336516b1f4530a54643c383d03b64fda24f864455a28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42ebe727cba220970984359ef5487294c68f8011ce57ae2072176454b1bff1e8"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "openjdk" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "icu4c"
  depends_on "protobuf"
  depends_on "re2"

  fails_with gcc: "5" # For abseil and C++17

  def install
    ENV.append_to_cflags "-Wno-sign-compare" # Avoid build failure on Linux.
    system "cmake", "-S", "cpp", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=17", # keep in sync with C++ standard in abseil.rb
                    "-DGTEST_INCLUDE_DIR=#{Formula["googletest"].opt_include}",
                     *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <phonenumbers/phonenumberutil.h>
      #include <phonenumbers/phonenumber.pb.h>
      #include <iostream>
      #include <string>

      using namespace i18n::phonenumbers;

      int main() {
        PhoneNumberUtil *phone_util_ = PhoneNumberUtil::GetInstance();
        PhoneNumber test_number;
        string formatted_number;
        test_number.set_country_code(1);
        test_number.set_national_number(6502530000ULL);
        phone_util_->Format(test_number, PhoneNumberUtil::E164, &formatted_number);
        if (formatted_number == "+16502530000") {
          return 0;
        } else {
          return 1;
        }
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lphonenumber", "-o", "test"
    system "./test"
  end
end
