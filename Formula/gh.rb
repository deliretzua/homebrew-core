class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.28.0.tar.gz"
  sha256 "cf3c0fb7f601d717d8b5177707a197c49fd426f5dc3c9aa52a932e96ba7166af"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc0c9ba418c675a94a4215e263e5d2452bc62a3b91cf6050e5de56b3c9a628b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc0c9ba418c675a94a4215e263e5d2452bc62a3b91cf6050e5de56b3c9a628b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc0c9ba418c675a94a4215e263e5d2452bc62a3b91cf6050e5de56b3c9a628b9"
    sha256 cellar: :any_skip_relocation, ventura:        "5d9e9541e1d1140d0018853de6b12f0f0517db361692e61dfb6b5ded84dd5946"
    sha256 cellar: :any_skip_relocation, monterey:       "5d9e9541e1d1140d0018853de6b12f0f0517db361692e61dfb6b5ded84dd5946"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d9e9541e1d1140d0018853de6b12f0f0517db361692e61dfb6b5ded84dd5946"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "392514356345014165a5916def27830a762fcf65ce2102fa29303ff45e55cb16"
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
