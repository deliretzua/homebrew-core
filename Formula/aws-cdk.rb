require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.63.1.tgz"
  sha256 "0de2953af684ad4feefa47394c4da0196c632a819c19e535a51f885809426196"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5254455b0bb1ec2d442765516d6aa7efb1bf0d094996f6c5a0cf21517786a9a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5254455b0bb1ec2d442765516d6aa7efb1bf0d094996f6c5a0cf21517786a9a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5254455b0bb1ec2d442765516d6aa7efb1bf0d094996f6c5a0cf21517786a9a"
    sha256 cellar: :any_skip_relocation, ventura:        "fdc3e152dc9eedec83968aabe2c869483e19e449f731a890686d1a42c2beb786"
    sha256 cellar: :any_skip_relocation, monterey:       "fdc3e152dc9eedec83968aabe2c869483e19e449f731a890686d1a42c2beb786"
    sha256 cellar: :any_skip_relocation, big_sur:        "fdc3e152dc9eedec83968aabe2c869483e19e449f731a890686d1a42c2beb786"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edec6859931959450c465b60f7347da13abdb6ef31defde0586f46187ede9995"
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
