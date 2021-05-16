require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.29.15.tgz"
  sha256 "16114f23fe56482f07c4186ccf982be1a23814513cd0e0a749a8f98ed21d0455"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d1cb3958011d0cbc1d6e6cd0e960b3e5f6e5ec3d221c94bf985a5b00bec45a68"
    sha256 cellar: :any_skip_relocation, big_sur:       "d3beee9ae796e9e8cf0c7402b4d67d7336ea5b2e46f1bd41b640417c530252e8"
    sha256 cellar: :any_skip_relocation, catalina:      "d3beee9ae796e9e8cf0c7402b4d67d7336ea5b2e46f1bd41b640417c530252e8"
    sha256 cellar: :any_skip_relocation, mojave:        "d3beee9ae796e9e8cf0c7402b4d67d7336ea5b2e46f1bd41b640417c530252e8"
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/netlify login
      expect "Opening"
    EOS
    assert_match "Logging in", shell_output("expect -f test.exp")
  end
end
