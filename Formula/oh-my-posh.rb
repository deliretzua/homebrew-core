class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v15.4.3.tar.gz"
  sha256 "698d552458066e0884d7c0181d7a3e7b0ab460cfc75a20701e0173c82fcfe2c9"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6bdf5b8e1b69b67ad84b882415c444dc22256797a822c4ce8ce17796cb876d38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7e3700063b1ac979e50b862c11e34a62a40b9370c433861700be00f91890c52"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32454c274bd8938df7802d52b80bbf547a581df00aab883ca3ddfc1543d34b77"
    sha256 cellar: :any_skip_relocation, ventura:        "011b304a9ba76c08135457482e3acbc78655ba59821ccbcb73dd231aa83b735e"
    sha256 cellar: :any_skip_relocation, monterey:       "92fac89f3b1eba4bb4226d285c4f7b865e210da1db5017e9b4ebce48470ff31a"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc1134338da1eaad571575ed4ea2b402f89c3c47ea022d7935f3bdc75533e278"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c15034710660aef2383b5ee607085766990fa91bdb84df664580d4a1223699e4"
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
