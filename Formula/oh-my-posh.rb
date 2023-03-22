class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.16.0.tar.gz"
  sha256 "c4b9e743e9c7d92fb97a36203420ad9aa12f7d6f7a761630c527862e63a1613a"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "599e1a54c53582d20ae80a487c263bf1bef9850e40b4334c1f89736bc69e8d6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1dc623d245441c992e855558ad937ac6804752849343d8ecf6ade3eb53e9b13a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3d8eb8e1c23b17751cd2f5cb2e212f5053ede2688e00f8c96978f9f5e6bcbac"
    sha256 cellar: :any_skip_relocation, ventura:        "ac366e5a74fb560d982a1fc67c661daeb31ddef4c0e9ee4625a2dd9a76871151"
    sha256 cellar: :any_skip_relocation, monterey:       "6a9c6daa5f49e630566558f7adc20c40aa7389f002e2d244603d05343b9d912a"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b71e8df7cfb0c6eb3bf126996a5b2ee808c7eb7983102c2abfa5cfa3180bf77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44b2ba2324129254ac0513785512aba15f791c13f78b841a027a1c96af23075d"
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
