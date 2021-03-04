class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://github.com/CastXML/CastXML/archive/v0.4.3.tar.gz"
  sha256 "3dd94096e07ffe103b2a951e4ff0f9486cc615b3ef08e95e5778eaaec667fb65"
  license "Apache-2.0"
  head "https://github.com/CastXML/castxml.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "488e069f2dc774445f2c4d43e89df2ae957c1e7b24a85956c616571e1820a259"
    sha256 cellar: :any, big_sur:       "989198511ef4dad304cbe576e3ffe96338f0a2e29666c9dc282cce5a9a8d141b"
    sha256 cellar: :any, catalina:      "5dccf770e20f92a001e749bbf64cecd63bbe7005457eeb35214c98cf260a777f"
    sha256 cellar: :any, mojave:        "23cc8ef13e38b9aaeeac8a8023e66639f6c61b2e7e9472817c9343c6a6a3d060"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      int main() {
        return 0;
      }
    EOS
    system "#{bin}/castxml", "-c", "-x", "c++", "--castxml-cc-gnu", "clang++",
                             "--castxml-gccxml", "-o", "test.xml", "test.cpp"
  end
end
