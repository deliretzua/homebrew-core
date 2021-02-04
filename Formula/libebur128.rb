class Libebur128 < Formula
  desc "Library implementing the EBU R128 loudness standard"
  homepage "https://github.com/jiixyj/libebur128"
  url "https://github.com/jiixyj/libebur128/archive/v1.2.5.tar.gz"
  sha256 "165ea2ed15660dc334acf306169fe9d5ccd2b1371afefc5b80fc958c78045c8b"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "a7bf5352cb8a4609f3cc551bd5665c7153ceb9e01694c9b296733bf2451ec077"
    sha256 cellar: :any, big_sur:       "b8cf97cd17ccdc2daa202d568c409c4ce973bd55b68e38b31e2838ff5066c6b7"
    sha256 cellar: :any, catalina:      "f9bb6bf89d6a32835102ab859e88ab118812ea7920ab1e4416f7ff7f9b2692a6"
    sha256 cellar: :any, mojave:        "c51ca6f8e17f7558f35f4c156e7baba1e2658d475dc09eea1b2695e1b1771d42"
    sha256 cellar: :any, high_sierra:   "68c4f6d13808ad4d55d0a0f48384e9872286b6041a06f8c3984ccb96083fcbee"
    sha256 cellar: :any, sierra:        "d4611c0f7becaf4fbdc34089ddaae18e8017ed6dec859adf4fdadb528f989ae4"
    sha256 cellar: :any, el_capitan:    "3fbb561a893cd7e0858ad25e424e66f70a53023865b33d3519fb1fa62ab35bec"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "speex"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <ebur128.h>
      int main() {
        ebur128_init(5, 44100, EBUR128_MODE_I);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lebur128", "-o", "test"
    system "./test"
  end
end
