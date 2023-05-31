class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https://github.com/pingcap/tidb"
  url "https://github.com/pingcap/tidb/archive/refs/tags/v7.1.0.tar.gz"
  sha256 "6f865ef2d25b1bfe250936d45f65cf64e1b638b3d718fc0595e64f2da35daf56"
  license "Apache-2.0"
  head "https://github.com/pingcap/tidb.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed7c4087cf5b7d70ef51912cfb942ef61e87e210036bb506141e6cf17bc70633"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "054db56e85fb785f7d86ab62508328af5af2a247662ee21571561f2defd01e38"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02053804b86b0c0f04a47b38b7e9d9cb0ed5d2973edd8a7d403e58c025fe462d"
    sha256 cellar: :any_skip_relocation, ventura:        "537256bf8428d641f23397b4c9a0c95a738d6c6d3e6b08292c5074be2c4729f7"
    sha256 cellar: :any_skip_relocation, monterey:       "d771b904e91d4f6e70eb0a166745c6a0e0b1730019e3a06857d95b6a26306aa6"
    sha256 cellar: :any_skip_relocation, big_sur:        "27caf6466d45f1e24294ca728687648ea1a02d62fbda0eac22f01ef1df2a5521"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40fa874b92532003de28228ea0d7365c2d171a674a7444a97a97f26f4522655c"
  end

  depends_on "go" => :build

  def install
    project = "github.com/pingcap/tidb/dumpling"
    ldflags = %W[
      -s -w
      -X #{project}/cli.ReleaseVersion=#{version}
      -X #{project}/cli.BuildTimestamp=#{time.iso8601}
      -X #{project}/cli.GitHash=brew
      -X #{project}/cli.GitBranch=#{version}
      -X #{project}/cli.GoVersion=go#{Formula["go"].version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./dumpling/cmd/dumpling"
  end

  test do
    output = shell_output("#{bin}/dumpling --database db 2>&1", 1)
    assert_match "create dumper failed", output

    assert_match "Release version: #{version}", shell_output("#{bin}/dumpling --version 2>&1")
  end
end
