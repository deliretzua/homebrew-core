class Erdtree < Formula
  desc "Multi-threaded file-tree visualizer and disk usage analyzer"
  homepage "https://github.com/solidiquis/erdtree"
  url "https://github.com/solidiquis/erdtree/archive/refs/tags/1.7.0.tar.gz"
  sha256 "1b915240f484907aef0f4409b92d1bef1aed362d91bab84e56c732548ba228aa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f263c61b5d6fd9791a7fcb6652b8aa016dd3c49725d61a00b0a97c8a816c77a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e08cbb18b70d850cde4f5015887098c2ce06a3f60f0a03214406f2d032b1bfa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea3278c83c8f3b0427e443cfd719ea8bd0176c0a7a6425f9d8ec3a5ba0cda2b4"
    sha256 cellar: :any_skip_relocation, ventura:        "61e98d28ab868c4aedd1d4ed0216c808c303dacb5470f9451c0c59d2d05a6a7f"
    sha256 cellar: :any_skip_relocation, monterey:       "c2ddae1cd0bc62513d4daff4ee50afc96492434967c1d118a5b8f2f5f0525094"
    sha256 cellar: :any_skip_relocation, big_sur:        "9614d2ab25d27e97e6c29305c5eaae58b94ef3d7cc93092bb5a8aa37e99c933f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e5184b2549c8684ffd4d8d359d6c5c5cf1fd6d8a93efb660c24ad345c81ac21"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch "test.txt"
    assert_match "test.txt", shell_output("#{bin}/et")
  end
end
