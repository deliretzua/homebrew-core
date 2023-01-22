require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  # 1.19.0 introduced a big code layout change, which is not easy to patch.
  # TODO: re-add version throttling in next bump
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.19.1.tgz"
  sha256 "0e6ca9433f227a2a71e0f8527d530cb2e4cadf3864a7d6a614054af0ef8929ba"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c0c6d21aa76f1dc77a5b35223a54b5789134e3847cf6ddc22b0edae37ad1378"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c0c6d21aa76f1dc77a5b35223a54b5789134e3847cf6ddc22b0edae37ad1378"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c0c6d21aa76f1dc77a5b35223a54b5789134e3847cf6ddc22b0edae37ad1378"
    sha256 cellar: :any_skip_relocation, ventura:        "6d6b84d4b682014a6a9992c9989b3eab3e085fb26d743beb7346ac47579649c8"
    sha256 cellar: :any_skip_relocation, monterey:       "6d6b84d4b682014a6a9992c9989b3eab3e085fb26d743beb7346ac47579649c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d6b84d4b682014a6a9992c9989b3eab3e085fb26d743beb7346ac47579649c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c0c6d21aa76f1dc77a5b35223a54b5789134e3847cf6ddc22b0edae37ad1378"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
