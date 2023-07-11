class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v2.31.4.tar.gz"
  sha256 "f5fa6363d1a26dc922948d5c56cdf7b15cff31de488d7e6df81988e024d59667"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "beb44647758bba09a8b39d7279708a30439f20202845f7e07f0695e078d74327"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afb1fcb76b2da4a8727a0c56b13af7467c6882a9e2cee3f2b4947d4ce20aaea2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "933992b225a2cba43194c2814ead17168aedc94fb8e67c0dbb98e02a7fcfb9bc"
    sha256 cellar: :any_skip_relocation, ventura:        "b2d88a2805ecfd1cf739feeed3e9318c40698ef223f7a3202df4a363c95a6440"
    sha256 cellar: :any_skip_relocation, monterey:       "a14c07b9e6ef7ed973d06717f5fc8e13520eb38e1a7061f9b9d72ef52f97c702"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b14847f85b83d499e40e0be9d3d7b11aae767503f0d93fd2f7a4ab0159770a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4a7ecafd17c0e4d2ef7276f0048d64e38975ed19a6d0f35bc5a1a6310caa51b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v2/pkg/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end
