class Circumflex < Formula
  desc "Hacker News in your terminal"
  homepage "https://github.com/bensadeh/circumflex"
  url "https://github.com/bensadeh/circumflex/archive/refs/tags/2.9.tar.gz"
  sha256 "4d1280a03223ac38f084be305880527250c315f6c6658e2444b6a295e8ec147e"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "804bab531d0a999d7cdbe325de7d54b7ca56c3488eacdef7cd2822b7a0eb94b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "804bab531d0a999d7cdbe325de7d54b7ca56c3488eacdef7cd2822b7a0eb94b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "804bab531d0a999d7cdbe325de7d54b7ca56c3488eacdef7cd2822b7a0eb94b9"
    sha256 cellar: :any_skip_relocation, ventura:        "6c31ecc21b4853b0b954f41045183774c3eae05f0e63e3d3d1fc8998ca1b3680"
    sha256 cellar: :any_skip_relocation, monterey:       "6c31ecc21b4853b0b954f41045183774c3eae05f0e63e3d3d1fc8998ca1b3680"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c31ecc21b4853b0b954f41045183774c3eae05f0e63e3d3d1fc8998ca1b3680"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0e234de95637ad36b98f9b702861d5be1d34bee5a9043b4efdee87a6f0dae1f"
  end

  depends_on "go" => :build
  depends_on "less"

  def install
    system "go", "build", *std_go_args(output: bin/"clx", ldflags: "-s -w")
    man1.install "share/man/clx.1"
  end

  test do
    assert_match "List of visited IDs cleared", shell_output("#{bin}/clx clear 2>&1")
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    assert_match "Y Combinator", shell_output("#{bin}/clx view 1")
  end
end
