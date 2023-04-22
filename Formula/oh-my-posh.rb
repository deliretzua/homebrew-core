class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.32.0.tar.gz"
  sha256 "88c8f345c0edc28f2dc353f75be3b49d1fad575e70735e5f5bd57ff54367e001"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "932568ad221fbf60f46a312afa57e1d8b5be7295a44164cb5a0a5ecff3a455e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8d24c7e1faf3b9cdb04d2b76f77f178aa732a19310dc2fbeef9762c154d4b07"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53532f0bf6bc8eba8c1e4fc3bef13e1f12613cd282230d45490208aff0737959"
    sha256 cellar: :any_skip_relocation, ventura:        "284aa36e51c0e654980f469b6b4e2e8f879fc043af12020ea1c6632fd0d62e32"
    sha256 cellar: :any_skip_relocation, monterey:       "73d76ffef322f873d75b348cea93c03562bb9d5faa9fd8bde781f8cf8b5913d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff84967e9d50baac1c865fc7e28b7c5e987cc80b46368cf6913a2de237b2d675"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ffd65959d054e48323f4c290fd1f8e739e2a5962c94ddbc3421a191ff7fbb33"
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
