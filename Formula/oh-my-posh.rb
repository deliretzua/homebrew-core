class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v17.11.1.tar.gz"
  sha256 "4e5f08e846e734a980baa5472f29d643c27589a3a0ef347b3e8b974af117b4ee"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e070af8d669c88f98ea9bfb89bd6c2894dca5010c5479f8eb90753ac57f3ab2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "984f0d6254c742357ce9d0015c6292c8b09363a62e549373d5a0a309657cf699"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c39bf6718a96a5372dc9e28f21ead3b476fd175c859c86f5372c7a42fdb9156a"
    sha256 cellar: :any_skip_relocation, ventura:        "772ceb8a825ecea0bc3274ed6251e925bbd53e6e87c6d3735a135444f3c927ec"
    sha256 cellar: :any_skip_relocation, monterey:       "651a0da6811d27e2b34cbd8751b02eea66d0ea7b8c96b9677aa173fa234efd94"
    sha256 cellar: :any_skip_relocation, big_sur:        "54a4653345afb095f53ddfef1e3c6c10ecb6aa1ebf672dd08fc26fd31ba93f0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db7e6642e267f2c5807df6af43034f1088f5b4561e2e544a7f0e5a1f0787ef47"
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
