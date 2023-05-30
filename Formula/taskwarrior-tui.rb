class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.24.2.tar.gz"
  sha256 "6f567acd8f0ba6009f20d9ba60078e2b999fddb0fdbcffa75f088c62679b2dc3"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c401e3e54d038d77a63ee54d65b547606c66d04e33a69c41bbc7fa3bbfb11620"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75910ade019437e7d638fb09f9e524b461cfca6955dca4cbe6bd6aad92f6aaf9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e09e0f0ae37500ce14756d7b056278029607f00e4c423307ea2dbeab1bfc333"
    sha256 cellar: :any_skip_relocation, ventura:        "b5fc86acf1761964f40f7b0fbda8eb982fb3bb54fc6082f4d2cd41842d9eadde"
    sha256 cellar: :any_skip_relocation, monterey:       "90a7b835807f93e92e751670069483ca2bccdc436250a2b05cbe8de263683374"
    sha256 cellar: :any_skip_relocation, big_sur:        "9617e6ea7c30199828faa5a1e0ef1424da9f0dc0e941bf7aacb7a0b8d8037917"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30ba80bbba92104105fa437d671cb68aee3e7c4fa74a07223d623a85fa8cbf99"
  end

  depends_on "rust" => :build
  depends_on "task"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "docs/taskwarrior-tui.1"
    bash_completion.install "completions/taskwarrior-tui.bash"
    fish_completion.install "completions/taskwarrior-tui.fish"
    zsh_completion.install "completions/_taskwarrior-tui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taskwarrior-tui --version")
    assert_match "a value is required for '--report <STRING>' but none was supplied",
      shell_output("#{bin}/taskwarrior-tui --report 2>&1", 2)
  end
end
