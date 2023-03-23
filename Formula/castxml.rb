class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://github.com/CastXML/CastXML/archive/v0.5.1.tar.gz"
  sha256 "a7b40b1530585672f9cf5d7a6b6dd29f20c06cd5edf34ef34c89a184a4d1a006"
  license "Apache-2.0"
  revision 1
  head "https://github.com/CastXML/castxml.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2d6eceb20777bb59b421edc9d11522001cfb57403f9310b73eea09f13f7855b6"
    sha256 cellar: :any,                 arm64_monterey: "cc7fa1de35722860497a29f388e7b00a825addb5a9ee9c4f884f228e52ffa88e"
    sha256 cellar: :any,                 arm64_big_sur:  "97bb227c0f0ad8c9240c0035d8a0f9cd8508bfbd3cc2c9ffdcd28234c3a916b9"
    sha256 cellar: :any,                 ventura:        "a1434aa8662f1c913dba97d70e74811375b931259ad8bfb113097b793314989f"
    sha256 cellar: :any,                 monterey:       "cf2ac3221a590685146fd7c290fcabbb123ae433752e678f80317a6daac68316"
    sha256 cellar: :any,                 big_sur:        "b9e92b973387aba647015f6e8e8416294a052a00ed90df94a2c523b1daca5661"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dee2ceedc9922dcdabdd7f30c239de34d42a0e56336f6434ba1375086677167b"
  end

  depends_on "cmake" => :build
  depends_on "llvm@15"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    ENV.prepend_path "PATH", Formula["llvm@15"].opt_bin
    (testpath/"test.cpp").write <<~EOS
      int main() {
        return 0;
      }
    EOS
    system bin/"castxml", "-c", "-x", "c++", "--castxml-cc-gnu", "clang++",
                          "--castxml-gccxml", "-o", "test.xml", "test.cpp"
  end
end
