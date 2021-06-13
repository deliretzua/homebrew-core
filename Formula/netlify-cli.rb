require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.37.17.tgz"
  sha256 "bc31bd45c0d75710d7a2a2f2e63f158950c85090d11423d92f01e8c8081412fb"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b884905fab5fe368303b23ccc0a7f0b72853c244d138f8fc8fa7e51e2fac4950"
    sha256 cellar: :any_skip_relocation, big_sur:       "bdcaeedc4f8635bd91339813e4aadae1d0a4deeb7455757bbb45fe775c340d9b"
    sha256 cellar: :any_skip_relocation, catalina:      "bdcaeedc4f8635bd91339813e4aadae1d0a4deeb7455757bbb45fe775c340d9b"
    sha256 cellar: :any_skip_relocation, mojave:        "bdcaeedc4f8635bd91339813e4aadae1d0a4deeb7455757bbb45fe775c340d9b"
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
