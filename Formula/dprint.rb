class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.38.2.tar.gz"
  sha256 "de3730ad101cb1af3804da2c1089442157eaf8b2039218c536d9f114ec09a390"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07d72517ef360111bdb1620f1debce03bf317dbb4816c75c49de1c85fceec912"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8fe6eb40442508039fc30c5672a0102d5307c8d982cd49c7b56f8ce818dc1537"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd03cba1befff88cc451d984864d240bb2390bfc4e9b6777869bdb4d281307c1"
    sha256 cellar: :any_skip_relocation, ventura:        "f802268ee2c2bba2a0325b1bf385a2b5c8148993294eac0693b63c5443b4b2bd"
    sha256 cellar: :any_skip_relocation, monterey:       "d7a7e292ad5369e8608c5efa059fdfcc7f5dca5147e77a9df4db8ba8c7379def"
    sha256 cellar: :any_skip_relocation, big_sur:        "14b8e7d2df405c632169584dfe7a50b02bfddf8d9957f7232bca80975e8462f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f10c1adbd1dbd356ef325e9b37c88e5cdb8acd4491213da5a543d53f6a2987f"
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
