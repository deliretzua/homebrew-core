class Ilmbase < Formula
  desc "OpenEXR ILM Base libraries (high dynamic-range image file format)"
  homepage "https://www.openexr.com/"
  # NOTE: Please keep these values in sync with openexr.rb when updating.
  url "https://github.com/openexr/openexr/archive/v2.5.5.tar.gz"
  sha256 "59e98361cb31456a9634378d0f653a2b9554b8900f233450f2396ff495ea76b3"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_big_sur: "e00555535d8beaf7bdc54686c4841072f934460cd2c2326c73a142cd0a642a5e"
    sha256 big_sur:       "96c25377e22df725dff159ed26a7664448e7ba4a7fd90924532b1ed67c1c76c2"
    sha256 catalina:      "dc14e8650e42b22189ce338e9c8593dd29a81c68d1a915e104651a97b3f1f7ab"
    sha256 mojave:        "5f64d530a2162ca1a7b042704f0ba38de1b9efde4742ee76cbde3172af7612ac"
  end

  depends_on "cmake" => :build

  def install
    cd "IlmBase" do
      system "cmake", ".", *std_cmake_args, "-DBUILD_TESTING=OFF"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~'EOS'
      #include <ImathRoots.h>
      #include <algorithm>
      #include <iostream>

      int main(int argc, char *argv[])
      {
        double x[2] = {0.0, 0.0};
        int n = IMATH_NAMESPACE::solveQuadratic(1.0, 3.0, 2.0, x);

        if (x[0] > x[1])
          std::swap(x[0], x[1]);

        std::cout << n << ", " << x[0] << ", " << x[1] << "\n";
      }
    EOS
    system ENV.cxx, "-I#{include}/OpenEXR", "-o", testpath/"test", "test.cpp"
    assert_equal "2, -2, -1\n", shell_output("./test")
  end
end
