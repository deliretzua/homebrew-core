require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.53.0.tgz"
  sha256 "6ac070af25a50711d69c2e263f98e149b707d6e2c58bfe5b294288423bb7bb87"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5928dbdc82a23db0f94fb055cd13379b7be9d5cf197996d1bba86eac2a3c30a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5928dbdc82a23db0f94fb055cd13379b7be9d5cf197996d1bba86eac2a3c30a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5928dbdc82a23db0f94fb055cd13379b7be9d5cf197996d1bba86eac2a3c30a"
    sha256 cellar: :any_skip_relocation, monterey:       "a4aec2346b6dc627f073e8b5c24f535764940739f09b90be798b8af38d714bf4"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4aec2346b6dc627f073e8b5c24f535764940739f09b90be798b8af38d714bf4"
    sha256 cellar: :any_skip_relocation, catalina:       "a4aec2346b6dc627f073e8b5c24f535764940739f09b90be798b8af38d714bf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b7af835be8cdbd38662593761f8f94c39a2ec1b264bb16ae2e4e57712e1b157"
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
