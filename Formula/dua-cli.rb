class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.14.11.tar.gz"
  sha256 "31c95fc4e9e034f9ba892397dc3d3844635c6b03852983fcf3b0cc326b751c83"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9c1ac312c7718acd6ac3b83b60b465dd6d2c7bb5c3048b2dd54c677593a5765"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8923cd1646326c673b4ca20088c80ea0c587628e43d46424f9c59513714a17b3"
    sha256 cellar: :any_skip_relocation, monterey:       "405e658ca89efe95df50113056aaa354c10c7238f92acfdca40a54d5a04d787c"
    sha256 cellar: :any_skip_relocation, big_sur:        "504ada084b61ba06a5117027950ce7124a100285414f8e342f61704c5e775e3f"
    sha256 cellar: :any_skip_relocation, catalina:       "fe333d8aadf59a44a6f72166d4f60eacb4b36c8920b369c0c8605ac665f69015"
    sha256 cellar: :any_skip_relocation, mojave:         "ccc0aa70b2ec1e1068b5253466841daa5e1b7b62767ce2b80c5c86a5a9762d29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2be28c11b363fcc6e846f5db33270ea7890834e19703fe093e8fb9c8b8455b1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test that usage is correct for these 2 files.
    (testpath/"empty.txt").write("")
    (testpath/"file.txt").write("01")

    # The "-EOS" is needed instead of "~EOS" in order to keep
    # the expected indentation at the start of each line.
    expected = <<-EOS
      0  B #{testpath}/empty.txt
      2  B #{testpath}/file.txt
      2  B total
    EOS

    assert_equal expected, shell_output("#{bin}/dua -A #{testpath}/*.txt")
  end
end
