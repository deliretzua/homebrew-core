class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.28.0/cli-v1.28.0.tar.gz"
  sha256 "9a0b433c02033cf3d257405d845592e2b7c2e38741027769bb97a8fd763aeeac"
  license "MIT"
  revision 1
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7dcb2706505e18ad794a5896005d6d5f6ef843614b63d201b64feed9b94e89a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7dcb2706505e18ad794a5896005d6d5f6ef843614b63d201b64feed9b94e89a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7dcb2706505e18ad794a5896005d6d5f6ef843614b63d201b64feed9b94e89a4"
    sha256 cellar: :any_skip_relocation, ventura:        "b1715d553b6fc34819146707396df21e1b57d2ffff9a447acab7cc96382522f7"
    sha256 cellar: :any_skip_relocation, monterey:       "b1715d553b6fc34819146707396df21e1b57d2ffff9a447acab7cc96382522f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1715d553b6fc34819146707396df21e1b57d2ffff9a447acab7cc96382522f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "282b33215334949a1f586ec1b23b9c0db94159138933abfab38952b7d6f754b4"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?

    system "make", "GLAB_VERSION=v#{version}"
    bin.install "bin/glab"
    generate_completions_from_executable(bin/"glab", "completion", "--shell")
  end

  test do
    system "git", "clone", "https://gitlab.com/cli-automated-testing/homebrew-testing.git"
    cd "homebrew-testing" do
      assert_match "Matt Nohr", shell_output("#{bin}/glab repo contributors")
      assert_match "This is a test issue", shell_output("#{bin}/glab issue list --all")
    end
  end
end
