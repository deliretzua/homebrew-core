class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/v2.15.0.tar.gz"
  sha256 "6d708828e4641c5c596376300363a24863975ff0a5567e26affc4197d498fed3"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b7f44367ecb76dc747c2105caf1195b5df6855eabcdaad2e3e0ff29ee0efe2d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7baf7345dfc901d3a56483bb574e183c873abde71ffa1c312c5515fc6a25831e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f8af088f1be5a3effecfc21a31680f178c770fde12a701f514c679efa235f9a"
    sha256 cellar: :any_skip_relocation, monterey:       "202adbc397c7ad8fca316b0ae590481bea60639dd42c7edb2e17f89ec88897d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "54604ef8a59a3e184b77763018959eb8d2878c9fa2a4b4ea105528ceff9febed"
    sha256 cellar: :any_skip_relocation, catalina:       "7f82c43e9158dfcb6f06e1cddc186dfc413ceb35cfdfe0d7b0e5b3d5b25348d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2a50e952de49bb4b0ee2ab4263af644cc785c71e52cd3dd5c5f33b371bfde05"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/vektra/mockery/v2/pkg/config.SemVer=v#{version}")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Walking dry-run=true version=v#{version}", output
  end
end
