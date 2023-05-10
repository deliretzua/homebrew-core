class Sqlcmd < Formula
  desc "Microsoft SQL Server command-line interface"
  homepage "https://github.com/microsoft/go-sqlcmd"
  url "https://github.com/microsoft/go-sqlcmd/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "dc0d6aa4006347640dc3948fbdcab73b4766a36b255c1597b82b623ac551b15f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3de3d6e8b1dfd8469f4e1f9628f77ac9aabeac05c04bf7ddf2b75911a44b7f2d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3de3d6e8b1dfd8469f4e1f9628f77ac9aabeac05c04bf7ddf2b75911a44b7f2d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3de3d6e8b1dfd8469f4e1f9628f77ac9aabeac05c04bf7ddf2b75911a44b7f2d"
    sha256 cellar: :any_skip_relocation, ventura:        "e1751cd8e40e6934c0de652873cca0535d016cd81e6caeefdfe4cba0041861f5"
    sha256 cellar: :any_skip_relocation, monterey:       "e1751cd8e40e6934c0de652873cca0535d016cd81e6caeefdfe4cba0041861f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1751cd8e40e6934c0de652873cca0535d016cd81e6caeefdfe4cba0041861f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36465227b7678a44df53502db88b8277b3d9e7dbbc889161c64a3e883c1d7f4f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/modern"

    generate_completions_from_executable(bin/"sqlcmd", "completion")
  end

  test do
    out = shell_output("#{bin}/sqlcmd -S 127.0.0.1 -E -Q 'SELECT @@version'", 1)
    assert_match "connection refused", out

    assert_match "sqlcmd: #{version}", shell_output("#{bin}/sqlcmd --version")
  end
end
