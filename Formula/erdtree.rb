class Erdtree < Formula
  desc "Multi-threaded file-tree visualizer and disk usage analyzer"
  homepage "https://github.com/solidiquis/erdtree"
  url "https://github.com/solidiquis/erdtree/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "4bd3a24e34cacd595d80e04adce8786c2491850749aed2f534e07a2387573669"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "488e7376862936f4849a2b82c491c4bb839cb0816e1b1ff6bde785092729cef5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a03b7db6b5780e026c1928236e3d894c0cf6637eec6bd72d3de1b3e6d8dfd9be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29573f028e196d637735b894c45863f869288d796928c13bb195d38edcf904de"
    sha256 cellar: :any_skip_relocation, ventura:        "e98f2bdf9ff25960669a65726c5484185bc1843dfd184ab9c93e4d09dd1226d5"
    sha256 cellar: :any_skip_relocation, monterey:       "59d1f42bf032ab7e8228c6f62e5e69c38e6716add6468fb5645eb98fe7650ed0"
    sha256 cellar: :any_skip_relocation, big_sur:        "2249383419f59b7147680631400340cd6abbd8b5896eaf8e201a1c19d3f180b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e90a6aa5ca61b282f460df598e15b48c83133a686fe715d4a788949fb5a3f32"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"erd", "--completions")
  end

  test do
    touch "test.txt"
    assert_match "test.txt", shell_output("#{bin}/erd")
  end
end
