class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://github.com/errata-ai/vale/archive/v2.25.1.tar.gz"
  sha256 "22dd19b66e1c59a5323a1fb908ddbbfdd8699134292339f58c73dfdc85831eca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b34645a80c018eec8d6a786c5b2969a06b0300a871b997df4428f19774b3c21c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b34645a80c018eec8d6a786c5b2969a06b0300a871b997df4428f19774b3c21c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b34645a80c018eec8d6a786c5b2969a06b0300a871b997df4428f19774b3c21c"
    sha256 cellar: :any_skip_relocation, ventura:        "1ff922a9ef9dd57bb69ffb88c845d53e15a9258e17ee3f4d08a391dd2649009e"
    sha256 cellar: :any_skip_relocation, monterey:       "1ff922a9ef9dd57bb69ffb88c845d53e15a9258e17ee3f4d08a391dd2649009e"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ff922a9ef9dd57bb69ffb88c845d53e15a9258e17ee3f4d08a391dd2649009e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba2e15daba9f6fac5b84b7e0220fc4167f13b8aa1be0a510e9bc845fa93efecf"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -s -w"
    system "go", "build", *std_go_args, "-ldflags=#{ldflags}", "./cmd/vale"
  end

  test do
    mkdir_p "styles/demo"
    (testpath/"styles/demo/HeadingStartsWithCapital.yml").write <<~EOS
      extends: capitalization
      message: "'%s' should be in title case"
      level: warning
      scope: heading.h1
      match: $title
    EOS

    (testpath/"vale.ini").write <<~EOS
      StylesPath = styles
      [*.md]
      BasedOnStyles = demo
    EOS

    (testpath/"document.md").write("# heading is not capitalized")

    output = shell_output("#{bin}/vale --config=#{testpath}/vale.ini #{testpath}/document.md 2>&1")
    assert_match(/✖ .*0 errors.*, .*1 warning.* and .*0 suggestions.* in 1 file\./, output)
  end
end
