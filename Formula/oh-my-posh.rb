class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.23.0.tar.gz"
  sha256 "ccd6027c7bf94cad2080ab245a0d26cdd85f98673eee4a7cf11cbf3d334a8c73"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e7e6464b735c83fe70cf18b909d4051c40cc69357948594396cfd55a0262a43"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd3ed8d52e46e639b349dff5f423ea4762d9858a45851b97e1f375c74e963186"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "280c82321146797d5a517213776df6d026eeb75dc7f83ca0ac9aefd1453aa34c"
    sha256 cellar: :any_skip_relocation, ventura:        "540d76b82706ba711517483a7b323c824c1c446507be9334a9e8807fb4347628"
    sha256 cellar: :any_skip_relocation, monterey:       "d0dbf631b9a3e9264f9a6919d0a47cd3ffbf54ba814f504da8900dbfa98c4741"
    sha256 cellar: :any_skip_relocation, big_sur:        "d5daf0203d9420ecb780f1432cb570ba0664b967798cb388d28c5293140e166d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83f99c216de481cf836ea25b6e3026900c2b945967a4709ef6437d8b77c48de9"
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
