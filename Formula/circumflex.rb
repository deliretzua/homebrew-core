class Circumflex < Formula
  desc "Hacker News in your terminal"
  homepage "https://github.com/bensadeh/circumflex"
  url "https://github.com/bensadeh/circumflex/archive/refs/tags/3.1.tar.gz"
  sha256 "81212e22899057c5cd85e9295582580ee7c5cc0c186c6635d2b824573999919d"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4cd519394623899ab24c37305fa43eea41f59cf059e267435d94a1e330ea989b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4cd519394623899ab24c37305fa43eea41f59cf059e267435d94a1e330ea989b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4cd519394623899ab24c37305fa43eea41f59cf059e267435d94a1e330ea989b"
    sha256 cellar: :any_skip_relocation, ventura:        "2105b7de1bc05d5c043a8c12e09c4474603ec46fc268a17ffe9ddcd746be0d03"
    sha256 cellar: :any_skip_relocation, monterey:       "2105b7de1bc05d5c043a8c12e09c4474603ec46fc268a17ffe9ddcd746be0d03"
    sha256 cellar: :any_skip_relocation, big_sur:        "2105b7de1bc05d5c043a8c12e09c4474603ec46fc268a17ffe9ddcd746be0d03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99413012b7bafa9fe770e72970ecd38506255f14c17e05111a7bc2119e420228"
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
