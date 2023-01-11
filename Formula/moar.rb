class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.11.4.tar.gz"
  sha256 "4eae12ad5ed1fd8618dc323e42583248f259386a19e89b8effe49671b3af5e72"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9511747c20ba6fdd9d30ce5a8966add59b850792bd69c625c3c308a01450ac89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9511747c20ba6fdd9d30ce5a8966add59b850792bd69c625c3c308a01450ac89"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9511747c20ba6fdd9d30ce5a8966add59b850792bd69c625c3c308a01450ac89"
    sha256 cellar: :any_skip_relocation, ventura:        "0960696a7d48eb9214872d9f54fa9ef2f465b3296e9213b5a0a0ebc61802c86d"
    sha256 cellar: :any_skip_relocation, monterey:       "0960696a7d48eb9214872d9f54fa9ef2f465b3296e9213b5a0a0ebc61802c86d"
    sha256 cellar: :any_skip_relocation, big_sur:        "0960696a7d48eb9214872d9f54fa9ef2f465b3296e9213b5a0a0ebc61802c86d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7b34aab2089204882ea2c02b0beb0595a92e282b7fc5d1dd3f10a785cf99d37"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
    man1.install "moar.1"
  end

  test do
    # Test piping text through moar
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moar test.txt").strip
  end
end
