class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://github.com/go-delve/delve/archive/v1.21.0.tar.gz"
  sha256 "f00321e9333a61cb10c18141484c44ed55b1da1c4239a3f4faf2100b64613199"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "360209e24909c4c0d6951955b6ba0d6949479a0813a61862abfb6099681c6f4b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "360209e24909c4c0d6951955b6ba0d6949479a0813a61862abfb6099681c6f4b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "360209e24909c4c0d6951955b6ba0d6949479a0813a61862abfb6099681c6f4b"
    sha256 cellar: :any_skip_relocation, ventura:        "ba76ae52dea3bb3acf49f242e71e58f97f0d1d79eca64140ad5439c81d2de965"
    sha256 cellar: :any_skip_relocation, monterey:       "ba76ae52dea3bb3acf49f242e71e58f97f0d1d79eca64140ad5439c81d2de965"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba76ae52dea3bb3acf49f242e71e58f97f0d1d79eca64140ad5439c81d2de965"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ebdd5aaa0f359625f909c4b34a1425dbaabf0f2172d3bd24fededa073635f6f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"dlv"), "./cmd/dlv"
  end

  test do
    assert_match(/^Version: #{version}$/, shell_output("#{bin}/dlv version"))
  end
end
