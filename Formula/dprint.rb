class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.38.0.tar.gz"
  sha256 "778f9c327eb73f9fd7649485a13ce607315bfa2e436ccd40be85ebdb7d4f94e4"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d7a5ded2b3ebe1071641b60fe0a7e80492d7a4d0d08407252a72d8bb6841b35"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d9c68c8c74ae2c6edc6b1e7b4c903037724f3350043292059f734bc1ef7257f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "300ccc104706bdc86f1741f803b0dcae2d1dd7e53da78bdce768b3c16ee7bb30"
    sha256 cellar: :any_skip_relocation, ventura:        "abfccd6692d599078981aca0f674aaaa62f7df91d80b1ed04ca7ac106ae16ce1"
    sha256 cellar: :any_skip_relocation, monterey:       "d2f0566b17e6fa0381e77a22518e35a12e0641128d3cffe9809c9ddfdd7c008e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f22184bfd6608905b4ce012f8a42e32dc01f6033c5a17382d800f8ceb2e3f23f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9756f2eed1f1cb69dcff6fb77a3f1008e08b75fc19c4a306e625c63c1ec7cdc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/dprint")
  end

  test do
    (testpath/"dprint.json").write <<~EOS
      {
        "$schema": "https://dprint.dev/schemas/v0.json",
        "projectType": "openSource",
        "incremental": true,
        "typescript": {
        },
        "json": {
        },
        "markdown": {
        },
        "rustfmt": {
        },
        "includes": ["**/*.{ts,tsx,js,jsx,json,md,rs}"],
        "excludes": [
          "**/node_modules",
          "**/*-lock.json",
          "**/target"
        ],
        "plugins": [
          "https://plugins.dprint.dev/typescript-0.44.1.wasm",
          "https://plugins.dprint.dev/json-0.7.2.wasm",
          "https://plugins.dprint.dev/markdown-0.4.3.wasm",
          "https://plugins.dprint.dev/rustfmt-0.3.0.wasm"
        ]
      }
    EOS

    (testpath/"test.js").write("const arr = [1,2];")
    system bin/"dprint", "fmt", testpath/"test.js"
    assert_match "const arr = [1, 2];", File.read(testpath/"test.js")

    assert_match "dprint #{version}", shell_output("#{bin}/dprint --version")
  end
end
