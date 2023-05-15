require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-15.0.3.tgz"
  sha256 "264a6c265ed30fd50cc9246ce7a2b260648ca5c46b335e4abea8dae291d5b8da"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "c1a88c76b8b9dfa62d00025b92542ecc93f8120738d853a196e38af577a8ec3c"
    sha256                               arm64_monterey: "ce0154e4457ec81714ca794b8d24447f2903919ed339ad365a0ff9759744cdff"
    sha256                               arm64_big_sur:  "2c8170a8b3562e3201b01e17cb006e6977b3ac302fc27bba3104b2060bdf067f"
    sha256                               ventura:        "d615cbf780f37063345d3ec1c094c3b1001ef0902b34ca97854a08ffddcb3fe6"
    sha256                               monterey:       "ec997fea6f0859394ea1619c8a009bfb473af535a895dbe4911e6899ca90cee7"
    sha256                               big_sur:        "fcdc98d6b10c03c676ed8fc3336cbbd14dd3a201be00d87de9e8a7f7e341b010"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9050c4bb561254d150529993608f6e0c16497e4607cb9cf47f806a0f58f88f0f"
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
