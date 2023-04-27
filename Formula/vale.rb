class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://github.com/errata-ai/vale/archive/v2.25.1.tar.gz"
  sha256 "22dd19b66e1c59a5323a1fb908ddbbfdd8699134292339f58c73dfdc85831eca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2fa5a03164ae72bf6e5e7f586145516d364741c4ce155eb79b9a54ecd7b2dd3e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2fa5a03164ae72bf6e5e7f586145516d364741c4ce155eb79b9a54ecd7b2dd3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2fa5a03164ae72bf6e5e7f586145516d364741c4ce155eb79b9a54ecd7b2dd3e"
    sha256 cellar: :any_skip_relocation, ventura:        "753c0e3d4010fb5e2eeda665cebd786fa459d7066c1dfe6b5a1fbe61a10a680b"
    sha256 cellar: :any_skip_relocation, monterey:       "753c0e3d4010fb5e2eeda665cebd786fa459d7066c1dfe6b5a1fbe61a10a680b"
    sha256 cellar: :any_skip_relocation, big_sur:        "753c0e3d4010fb5e2eeda665cebd786fa459d7066c1dfe6b5a1fbe61a10a680b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c89eba79f29dfe965dd60e56416455ac9fe1189c06fec3aab9550c53ab985f6c"
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
