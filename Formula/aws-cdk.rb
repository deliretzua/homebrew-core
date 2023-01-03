require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.59.0.tgz"
  sha256 "d8a83b61f22893e85cccac3b5bddf058eef368f5c0e89ba897b9563c4d2bd2c0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52e66929d90e033cea0e3d4e2c2db4c24fc0e0775a96f91c50e403e05e23d661"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52e66929d90e033cea0e3d4e2c2db4c24fc0e0775a96f91c50e403e05e23d661"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52e66929d90e033cea0e3d4e2c2db4c24fc0e0775a96f91c50e403e05e23d661"
    sha256 cellar: :any_skip_relocation, ventura:        "af140b691e800b82770ca109088726a46d20b8901abef5305b5d0cfc741e3067"
    sha256 cellar: :any_skip_relocation, monterey:       "af140b691e800b82770ca109088726a46d20b8901abef5305b5d0cfc741e3067"
    sha256 cellar: :any_skip_relocation, big_sur:        "af140b691e800b82770ca109088726a46d20b8901abef5305b5d0cfc741e3067"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d84248bc737a256417472ded2b131db32a7ef0b81006d6bde51114f42b1f29d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with native slices.
    deuniversalize_machos
  end

  test do
    # `cdk init` cannot be run in a non-empty directory
    mkdir "testapp" do
      shell_output("#{bin}/cdk init app --language=javascript")
      list = shell_output("#{bin}/cdk list")
      cdkversion = shell_output("#{bin}/cdk --version")
      assert_match "TestappStack", list
      assert_match version.to_s, cdkversion
    end
  end
end
