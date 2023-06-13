require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-15.5.1.tgz"
  sha256 "01e22542c9363f1cdd2e5fc28727c37f513b4ac50662b92dd1e14a86efdf7acb"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "213d65c0bde85b80db44d37c1654d1e2c3735176568b8c68b24818589374e52c"
    sha256                               arm64_monterey: "69dc4634b33f20a755ddb5f49e4292e7fa4a8c0dc72bab036435cc4ae236c60c"
    sha256                               arm64_big_sur:  "9ca114f4014c3f017e49e56bd2d2ad9fbf7b2f60947b8faa92bd061e21ebe753"
    sha256                               ventura:        "b962ca4484310d18d56b0efe87dbf7f2ff7b6b7edf036ae87840ae74f7196298"
    sha256                               monterey:       "0f7a120af17b6b871b09bc4145707eaafdb4599d41131ce835351e97d63809b0"
    sha256                               big_sur:        "0b1355e6e7db8aabbd33dc2c95bf784f2da0123f6b5486cbcc37fb2da43aafab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a8886db8814a37901fe95d738868fed38dd2b76a98462031fe4fbc80bf04656"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}/netlify status")
  end
end
