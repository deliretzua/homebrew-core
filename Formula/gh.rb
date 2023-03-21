class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.25.1.tar.gz"
  sha256 "d3b28da03f49600697d2e80c2393425bd382e340040c34641bf3569593c7fbe8"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f2e20cd86e30f843bed9844568f812c350224750abee41c93fb67280edc2702"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f2e20cd86e30f843bed9844568f812c350224750abee41c93fb67280edc2702"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f2e20cd86e30f843bed9844568f812c350224750abee41c93fb67280edc2702"
    sha256 cellar: :any_skip_relocation, ventura:        "ffd47e72bbee59fb288d194215e9aa8cb88ce035f56f6b2ba750d1a955ec2c52"
    sha256 cellar: :any_skip_relocation, monterey:       "ffd47e72bbee59fb288d194215e9aa8cb88ce035f56f6b2ba750d1a955ec2c52"
    sha256 cellar: :any_skip_relocation, big_sur:        "ffd47e72bbee59fb288d194215e9aa8cb88ce035f56f6b2ba750d1a955ec2c52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67b39c67f627b5590f21cc3334f106feff5d7ad942fcdccfdf2a1ec8f081e55b"
  end

  depends_on "go" => :build

  def install
    with_env(
      "GH_VERSION" => version.to_s,
      "GO_LDFLAGS" => "-s -w -X main.updaterEnabled=cli/cli",
    ) do
      system "make", "bin/gh", "manpages"
    end
    bin.install "bin/gh"
    man1.install Dir["share/man/man1/gh*.1"]
    generate_completions_from_executable(bin/"gh", "completion", "-s")
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}/gh pr 2>&1")
  end
end
