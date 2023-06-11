class Circumflex < Formula
  desc "Hacker News in your terminal"
  homepage "https://github.com/bensadeh/circumflex"
  url "https://github.com/bensadeh/circumflex/archive/refs/tags/3.0.tar.gz"
  sha256 "a2e641d020b5dbd9bbfbeffe14983a29f481bdb22440e5971139cac3c1de6390"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "667a3dc6ba522812ebe5af5b01181109b75baf56543ad799d2135293375e7d48"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "667a3dc6ba522812ebe5af5b01181109b75baf56543ad799d2135293375e7d48"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "667a3dc6ba522812ebe5af5b01181109b75baf56543ad799d2135293375e7d48"
    sha256 cellar: :any_skip_relocation, ventura:        "961a714ee4ec73f18240d984e6d74a8cb886209bebbf8ded6e0b77986ff56114"
    sha256 cellar: :any_skip_relocation, monterey:       "961a714ee4ec73f18240d984e6d74a8cb886209bebbf8ded6e0b77986ff56114"
    sha256 cellar: :any_skip_relocation, big_sur:        "961a714ee4ec73f18240d984e6d74a8cb886209bebbf8ded6e0b77986ff56114"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70c2b31a6e563893211c6c93f41bf35ebb94fe149f97c6df2b8e274b78a6c1f3"
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
