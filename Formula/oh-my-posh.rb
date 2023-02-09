class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.2.5.tar.gz"
  sha256 "0d493852380ce2885c7e10310fbe3f15029e9a4e288e44b40bf1bf1ee3e28d29"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58eba2aa397196d140114c6da36bd8f23462bf1c0a5fafd440f190c78fbbb4f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "384fa388f8191630a26d45fac1fcf0614206b8a40c871f6a1b16bece549cf313"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a58b55b1404de5865ae2e4d7ff21ad359c1f0bcce980f49c89ad41d4b0834f24"
    sha256 cellar: :any_skip_relocation, ventura:        "04302b53bcd7cac190ec8097fecc01911e185fa07193daab2f20a9a1c6924675"
    sha256 cellar: :any_skip_relocation, monterey:       "b20bfe4e194c8a0970bab99f42ac37c5da965853e630e35a641b8888e1c9be5b"
    sha256 cellar: :any_skip_relocation, big_sur:        "07c42e4fdf76fae13b694941596e09cc48285b97499a281cbf46d72cba9ff6de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8307a4cc38796d0a632b95d449c77a8d8ba655b0177c218df8668fe1f213f9af"
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
