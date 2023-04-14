require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.19.tgz"
  sha256 "8c70dd594d134347a742053ef216138a25bb20eac4309ea7e83aa7962a0b4a92"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a70d3f07111431a2aa3a804521c5c3a62a0647c53e07a3c8ff7b6e8eee87e7fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a70d3f07111431a2aa3a804521c5c3a62a0647c53e07a3c8ff7b6e8eee87e7fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a70d3f07111431a2aa3a804521c5c3a62a0647c53e07a3c8ff7b6e8eee87e7fe"
    sha256 cellar: :any_skip_relocation, ventura:        "8974e5c73c7a3ded036e2f4d23291ca2a11d5a42d1ae2d944425cfed1d69531d"
    sha256 cellar: :any_skip_relocation, monterey:       "8974e5c73c7a3ded036e2f4d23291ca2a11d5a42d1ae2d944425cfed1d69531d"
    sha256 cellar: :any_skip_relocation, big_sur:        "8974e5c73c7a3ded036e2f4d23291ca2a11d5a42d1ae2d944425cfed1d69531d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a70d3f07111431a2aa3a804521c5c3a62a0647c53e07a3c8ff7b6e8eee87e7fe"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"sample.json").write <<~EOS
      {
        "i": [0, 1],
        "s": "quicktype"
      }
    EOS
    output = shell_output("#{bin}/quicktype --lang typescript --src sample.json")
    assert_match "i: number[];", output
    assert_match "s: string;", output
  end
end
