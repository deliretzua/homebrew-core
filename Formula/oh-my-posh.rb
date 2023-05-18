class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v16.7.0.tar.gz"
  sha256 "6e8afa3b5e7e18cfe7489f53eccb66449554dbc1270fc7d4ba449d9873dfdd34"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d17195a9b58dd49c5d27952bf545a347934cd6e795e55cea68cef8d9d4124a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3025c443af1bc45c0cec1817a1103ee7ec625ad2227db7c9ddd45d4ca880989a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59a55ccecd37129e069a3d9a2373ea8d15f4c9bbb392c3d7459b71181f0034ec"
    sha256 cellar: :any_skip_relocation, ventura:        "337d20fbcced890ec082983bacd391278a52508866627b5155b59aa6a594e86a"
    sha256 cellar: :any_skip_relocation, monterey:       "3dba9565c8bf496fd03c484df3e9313304d90eb49fb11b44aea28d331034514d"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0f653cc3a8f13f9328c08824611ceb996dce8188e57a957fe9350582152b95e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19d62be94d18c6df21e2e48a12c96141aecb25e1fedc30a2e89334555373fd2c"
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
