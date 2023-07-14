class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v17.11.2.tar.gz"
  sha256 "e7f28d6051269cc0b66d2d8adea0c0fb5c0639fe49ad0a73d283b83b86058ca6"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5f34808187879fb4de61caaaf5d9628203cfa96c6f59eeb57997454050a943d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5754a7abe49cc540ac8354bfe01cc591f38614218e2b7386d33a28585cb7940"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea6d1de83dcf4aca359af59709ffeeec591db27130e6205a34d358f79a0dab60"
    sha256 cellar: :any_skip_relocation, ventura:        "62d9c61f3ebb963deacc9e90ad9b3a068a06b8a6e9bec134713972763914c141"
    sha256 cellar: :any_skip_relocation, monterey:       "40e13b79583aeda475471ed93cad1ef347bf63cf0bb2542a02d21202a31327ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ea8921715ef4ec638c9829273cb948d323b1d7dec5e73e2b9e5f9b4186ee008"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb012d10c191451d8806343849cfbf7e13fb0b785f07dece74df23cee4969aae"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end
