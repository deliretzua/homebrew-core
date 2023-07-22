class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://beta.ruff.rs/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/v0.0.280.tar.gz"
  sha256 "9ea57a4dbad87afabe4af6e2022ac09f23ee46eb24c7cb39ac36a52cd6350419"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "968c245984959d80f5fb656853885fc21ea172c5966a53c70c877cbe8d1c18d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d155efe63b827dcb425d4d5c60ea3ba312ef3292f740b6795b088d6296731aac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1943cf1cb098f0b1c2eb44e275c580a631df8d7cf043a56041a92df976a7ed92"
    sha256 cellar: :any_skip_relocation, ventura:        "fac757cedb231038fa770fb74e0635a56021d9df97532e1dd0b066d046313a10"
    sha256 cellar: :any_skip_relocation, monterey:       "1c81e1c8eff7e77ddaa5dc49a23f82137da21b4f9d572604157e90eb4a9e06ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "f24ff9c9681487bfe8044e90f9490bb0634dbdccdda942263af764dd34ab18d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50c8d16d7cab07121522ff0f8510320f45bf38462197942d43da6e38a4e92cd9"
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
