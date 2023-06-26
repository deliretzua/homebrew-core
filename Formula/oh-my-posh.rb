class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v17.5.2.tar.gz"
  sha256 "bbb7d10f7485237b937a38c216662beddfa02a6adb75f56f75ed7a52157da635"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0bd42594f9a415aa6f1fe4f9e28a4f5ac4af6381d68b75ac513ea6b52f133189"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02a3031e8ca7fd8b21296e8c679d281d9fd8c70c9fb91265eb60a48c797ebea2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c217f2232e7c559816b1ceb6b477fd5e66cd5e7e5ab21f73f24b10d4e2f82b4d"
    sha256 cellar: :any_skip_relocation, ventura:        "a1676769a0a5294024df180321af7c67b6ece3acbf5cbc246294dc1406d15fa3"
    sha256 cellar: :any_skip_relocation, monterey:       "19643d904fd84161d051cc5588dc0969d4a538c0213a67342381cee9a7d45456"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e69ad167023a42ca3253b833ba607f030cfd8cbd9cd98d702ab62bc617c6bda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e60808058a553c4de71549253f83a418bb6c18ea523bfb2d600b4051a726fafb"
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
