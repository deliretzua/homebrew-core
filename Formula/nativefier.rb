require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-42.4.0.tgz"
  sha256 "93ad382eccd95fee92bfe672a212d744146fdc7e7d7a8733ef11bda769cd59fe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4dcbc74067878f700b5f79691acd12eb23f01a2bea72654c4ec8d13e3778bb08"
    sha256 cellar: :any_skip_relocation, big_sur:       "a04329e00afb4b74b5d6d6053b942ecc153f0a372b07ef6f840325ae0cafb4ee"
    sha256 cellar: :any_skip_relocation, catalina:      "9555c9e9f56de3836e1e27b9891347ba697012333285031205ffce0f4a89775e"
    sha256 cellar: :any_skip_relocation, mojave:        "1b2b45a62a843fbe80e9639da1b1b952316287bc5db3d69f208f43f56f6f4734"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nativefier --version")
  end
end
