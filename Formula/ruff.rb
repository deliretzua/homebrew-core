class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.268.tar.gz"
  sha256 "8eb5b7c91cb7c09626f8247e98a16a2080a4d99728611cb08af0d7e1de3b2ec7"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92bee4594d893c009f22a767434496e881c31d340a4d31661092d7fa879f00ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "465536060f05a76c7ffa667af819a3f1bf285d7cd40337f36c6c7583b165d136"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79e25276e0ce0625c2b1861f3f2d1ecb8eddd7c8f17f2e679919bce0d5b21434"
    sha256 cellar: :any_skip_relocation, ventura:        "c36b94ee63bc0e0333d6669e272f23fbda950dc4c651b35624c4948cbb0697f5"
    sha256 cellar: :any_skip_relocation, monterey:       "37cb1ee8b60fb850a690c4d73c82e1ba9a1ee650c2a4b10b918bfa51b2553d18"
    sha256 cellar: :any_skip_relocation, big_sur:        "329124b639472c462a79d5afa87f15197a95edc3bbf3e77b1557f5f1d7e9a513"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e2545110e3570545a60965a3b53eb42938b85eef8611c6d1e3587f8b2dc0a1e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/ruff_cli")
    generate_completions_from_executable(bin/"ruff", "generate-shell-completion")
  end

  test do
    (testpath/"test.py").write <<~EOS
      import os
    EOS

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff --quiet #{testpath}/test.py", 1)
  end
end
