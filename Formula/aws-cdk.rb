require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.62.0.tgz"
  sha256 "3ebd3cf848418195cf545813ee6dab7410bb2e6204e8a9d425a4e00d81a64809"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41d3893101eb3614df1136ca2062bcaa0d2e9260ff537bfb6619c0fcde4d5319"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41d3893101eb3614df1136ca2062bcaa0d2e9260ff537bfb6619c0fcde4d5319"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41d3893101eb3614df1136ca2062bcaa0d2e9260ff537bfb6619c0fcde4d5319"
    sha256 cellar: :any_skip_relocation, ventura:        "f69d5e8e4d52b75d78c29160517b76d8f25c3a6b0e87846bfb23f6978cc734fc"
    sha256 cellar: :any_skip_relocation, monterey:       "f69d5e8e4d52b75d78c29160517b76d8f25c3a6b0e87846bfb23f6978cc734fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "f69d5e8e4d52b75d78c29160517b76d8f25c3a6b0e87846bfb23f6978cc734fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58dac910cab670bffa92548ce6a500b76ddcd7ef24e9b709e9f950eb97d295e1"
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
