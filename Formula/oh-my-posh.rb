class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.29.3.tar.gz"
  sha256 "a1a39bb6f213558c96f654c030eacf640b76ab8cb90c1c85587df14981a6ee2e"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95d6e6a5aee8a6f4586d16b44ae4292d703f91d0fef75fc20e2bd882b31956d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "847ac31c8721be87cadcac8dc4de340c6de2031aa5488745d0d6ac42dbc97aa4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ede7c4da1823264afe8bbd34804dd73c2f234f3ac58571237d2f00a0a70e9ef"
    sha256 cellar: :any_skip_relocation, ventura:        "224c28cf480e8d42fc1bec14fd05d69c88d54e7d84286b60753e9c40008b0f5a"
    sha256 cellar: :any_skip_relocation, monterey:       "82007b907a444ff63d7e8cf606320fcbca7e53cb260b7a82ba2c20f5ce47bfbd"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c8b029017d57dc8288ee5629f6fa0be55b0dcdf281a0441bde3d3c7e090bd3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d519d5ffce086cd3bb9209020ba7b4875c3b8afefaed5e928db2849af845797a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end
