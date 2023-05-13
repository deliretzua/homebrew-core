class Goawk < Formula
  desc "POSIX-compliant AWK interpreter written in Go"
  homepage "https://benhoyt.com/writings/goawk/"
  url "https://github.com/benhoyt/goawk/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "56467fe10d184ffaaf47fff7ede29c85be53af8b65c158bf5cab259a0de0a527"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "385ff3a6080e20123ea0d2239551620b97bf3c2021a222639a6ed20eb894a2d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "385ff3a6080e20123ea0d2239551620b97bf3c2021a222639a6ed20eb894a2d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "385ff3a6080e20123ea0d2239551620b97bf3c2021a222639a6ed20eb894a2d3"
    sha256 cellar: :any_skip_relocation, ventura:        "0e642fe42d04022d34347d52c2e3b500abe6cdb36d69f8373b81ecf7a61af521"
    sha256 cellar: :any_skip_relocation, monterey:       "0e642fe42d04022d34347d52c2e3b500abe6cdb36d69f8373b81ecf7a61af521"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e642fe42d04022d34347d52c2e3b500abe6cdb36d69f8373b81ecf7a61af521"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69399fe3132a8c0efda4ad3d599090b67412419507d9411d52dcb84b6640538c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = pipe_output("#{bin}/goawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end
