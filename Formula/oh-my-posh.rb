class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v15.2.0.tar.gz"
  sha256 "9b47045a236cf3479e3ea688a2fc023ed4a3b55c132b0e1bd2897b4d8b936f1f"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "635a77ae589465bfed89ad61c95f0fd6a587d890c8989bb6c9f06af4a0993873"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "873aa7064d49e71392b861d6eec6d78fdd1930b6642f032ef1aa73066c2e335f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff0bcae6500b44130fc28de1b62a8c579e1def7e6550a8eceb74ea58ba94fc4a"
    sha256 cellar: :any_skip_relocation, ventura:        "49fdf7df07652fc84a5d47b504c09e0dd045616fae334f9bfd6e54807b4d9ba2"
    sha256 cellar: :any_skip_relocation, monterey:       "99d949a8bd46098879fa3136ec4066f63c2dd759f58ce57e9a278acc69c48701"
    sha256 cellar: :any_skip_relocation, big_sur:        "40607fea7a8418d7ef82bc6b1ca127d894936b7b1f6d20a90f84175a60de09a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "558192010371a70ec04b58b376eb1214d1a7cd82287d801b2dfc49f116f011aa"
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
