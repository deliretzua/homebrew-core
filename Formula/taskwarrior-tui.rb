class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.25.0.tar.gz"
  sha256 "5c458b19713dd46ccd140ab2e08240f02e160b7904a8352b031acc383ad40c7c"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "920617eb09c9dab0fb504bde0c3920b0bfbc28ad5d86e6a03ed80bbb924b951f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9cf2472da61bd56a86f4467f294207bc1e7156ab95a8bad6c0dc6438b2ffd84"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79e51a417f65cd24ebfc447779ee3a1b66874e698979058080b143251b90d330"
    sha256 cellar: :any_skip_relocation, ventura:        "b41c1b44f5cad3cee5bf8d793c5d4f251ff1993d100918bd366bd8b134f01d44"
    sha256 cellar: :any_skip_relocation, monterey:       "550d3aa1ec6f2a2281971d44e3df749ab12112470fb415e7e71fa0aab4a5a33f"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a865237416f8e878c81b00cc759650b01622ea90d6a8f6eaabc9d98015f941f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5d3e36fd07616a1a68db25a7dad1ba4d6ef6204631be5c0b1daadc1574d688a"
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
