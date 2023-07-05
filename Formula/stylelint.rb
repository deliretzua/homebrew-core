require "language/node"

class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-15.10.0.tgz"
  sha256 "6893c11104cfdc796343664ded5a1b8d3c8e7dda8a3ffa6ae4bd342e43fa49b9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c8873a807b2e0221cbc34891e24aa19abf33b9db97590e865bde54034ba6a23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c8873a807b2e0221cbc34891e24aa19abf33b9db97590e865bde54034ba6a23"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c8873a807b2e0221cbc34891e24aa19abf33b9db97590e865bde54034ba6a23"
    sha256 cellar: :any_skip_relocation, ventura:        "29ec5c306c55b44415dadcdc9432b5d5f080d3715087c17314f405504a5831d3"
    sha256 cellar: :any_skip_relocation, monterey:       "29ec5c306c55b44415dadcdc9432b5d5f080d3715087c17314f405504a5831d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "29ec5c306c55b44415dadcdc9432b5d5f080d3715087c17314f405504a5831d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c8873a807b2e0221cbc34891e24aa19abf33b9db97590e865bde54034ba6a23"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".stylelintrc").write <<~EOS
      {
        "rules": {
          "block-no-empty": true
        }
      }
    EOS

    (testpath/"test.css").write <<~EOS
      a {
      }
    EOS

    output = shell_output("#{bin}/stylelint test.css 2>&1", 2)
    assert_match "Unexpected empty block", output

    assert_match version.to_s, shell_output("#{bin}/stylelint --version")
  end
end
