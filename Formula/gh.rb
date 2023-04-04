class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.26.1.tar.gz"
  sha256 "3552c0be9b24cf1b04b19f3cddc30f067a9761bd8872b591e02bf3147de5dd0e"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "836595ef0b3d47047e0c17552a2b3f0d82efa61a4de1a359f3a829256099041b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "836595ef0b3d47047e0c17552a2b3f0d82efa61a4de1a359f3a829256099041b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "836595ef0b3d47047e0c17552a2b3f0d82efa61a4de1a359f3a829256099041b"
    sha256 cellar: :any_skip_relocation, ventura:        "a5ef311b921c6ab62eafd92de96734aef334e2610b1ff080618ee8828dc97c46"
    sha256 cellar: :any_skip_relocation, monterey:       "a5ef311b921c6ab62eafd92de96734aef334e2610b1ff080618ee8828dc97c46"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5ef311b921c6ab62eafd92de96734aef334e2610b1ff080618ee8828dc97c46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f01d73af131fa36afc53396efeebfbae81eb87408e34c32e9363af69eed068f"
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
