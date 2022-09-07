class Bupstash < Formula
  desc "Easy and efficient encrypted backups"
  homepage "https://bupstash.io"
  url "https://github.com/andrewchambers/bupstash/releases/download/v0.11.1/bupstash-v0.11.1-src+deps.tar.gz"
  sha256 "9433379491e7552032620789a0f8a702159a0744484e3fd9fe73eb9eb1d71351"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c2b3bfbd7075c0a64304667421815bb529183f9eb9bde61ecaf79923d2925f1d"
    sha256 cellar: :any,                 arm64_big_sur:  "65104ae3ea862bc86dae1ce07a1c067ea45d88e75bea5926796faddfcbe6b5ab"
    sha256 cellar: :any,                 monterey:       "e99ed02f65489c64106daee7952490084ac1e3093b45fb99da915be587028db1"
    sha256 cellar: :any,                 big_sur:        "522831b729f52716a33cb2937453912dbd0c5c88edd962d120eae4ab7afa50f6"
    sha256 cellar: :any,                 catalina:       "281410e6ef86bf6645d4f31c7bb8a97ce60f47ac5ab5e16537ce4fd355324e2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a9b5ee63438c71becbe6899c64b79ab78110fb0782a9185f9108bc78071f478"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libsodium"

  resource "man" do
    url "https://github.com/andrewchambers/bupstash/releases/download/v0.11.1/bupstash-v0.11.1-man.tar.gz"
    sha256 "abbf79420e15e2619deb379d966e0b118ad67fcd411e52b1e642d8ba80b730bf"
  end

  def install
    system "cargo", "install", *std_cargo_args

    resource("man").stage do
      man1.install Dir["*.1"]
      man7.install Dir["*.7"]
    end
  end

  test do
    (testpath/"testfile").write("This is a test")

    system bin/"bupstash", "init", "-r", testpath/"foo"
    system bin/"bupstash", "new-key", "-o", testpath/"key"
    system bin/"bupstash", "put", "-k", testpath/"key", "-r", testpath/"foo", testpath/"testfile"

    assert_equal (testpath/"testfile").read,
      shell_output("#{bin}/bupstash get -k #{testpath}/key -r #{testpath}/foo id=*")
  end
end
