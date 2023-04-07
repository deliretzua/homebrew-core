class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.27.0.tar.gz"
  sha256 "ef75b9b844f29ac10908c66c46f8782f1c1631d587dc9d33b1e2c00321d93747"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "569a9c7198b8e8fba9aea3a7520c7ffcb480440301f1b5cc208db8a361e86b6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcd6e701474c9024e1f07ba748969b6ac9eb6afe885d368c1e03b8b6ed4039d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5be84a05f050ec9c774d6a55eae905973ff52b982b4db11bef35c026507c1745"
    sha256 cellar: :any_skip_relocation, ventura:        "63379e20f50bf2e19884ab2bd4a69f64fb899d1b808c60d75c9213873c5721b5"
    sha256 cellar: :any_skip_relocation, monterey:       "53bb9bb7ae0dfb1e36b0c32218b53133027f9ff8a9e5863a45c92e42efabc0ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "344117e313e77a662814be3e1af9d2a3350c4bccdaa87503a491713fad044e00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c98300e97063f43198080bf40bf4bd464737454040d6e75580fe7d1cf663e0a1"
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
