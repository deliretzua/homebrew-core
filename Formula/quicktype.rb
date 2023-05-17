require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.34.tgz"
  sha256 "b50ea9c10ca6724a7aba7ca072f697a5682b23f96e9c353777ac16a7f3f64192"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4905a67b485a45111ec2d08284c11ffa053e3e3007db137f5e3d9d9b7986eea0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4905a67b485a45111ec2d08284c11ffa053e3e3007db137f5e3d9d9b7986eea0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4905a67b485a45111ec2d08284c11ffa053e3e3007db137f5e3d9d9b7986eea0"
    sha256 cellar: :any_skip_relocation, ventura:        "793e9a4b5ab4579cfc8cbae7e4754e7851eb24dbda2825e7016ae614e27f6bce"
    sha256 cellar: :any_skip_relocation, monterey:       "793e9a4b5ab4579cfc8cbae7e4754e7851eb24dbda2825e7016ae614e27f6bce"
    sha256 cellar: :any_skip_relocation, big_sur:        "793e9a4b5ab4579cfc8cbae7e4754e7851eb24dbda2825e7016ae614e27f6bce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4905a67b485a45111ec2d08284c11ffa053e3e3007db137f5e3d9d9b7986eea0"
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
