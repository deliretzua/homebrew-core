require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.63.1.tgz"
  sha256 "0de2953af684ad4feefa47394c4da0196c632a819c19e535a51f885809426196"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b03ac5815ee5bf65c381d357f546ac39a3f1f3783c0ffd3172fa52cede4c6a46"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b03ac5815ee5bf65c381d357f546ac39a3f1f3783c0ffd3172fa52cede4c6a46"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b03ac5815ee5bf65c381d357f546ac39a3f1f3783c0ffd3172fa52cede4c6a46"
    sha256 cellar: :any_skip_relocation, ventura:        "8d8d2dfad3d286e38657b26d96dccce1414b32714d71bf90de29111a164df833"
    sha256 cellar: :any_skip_relocation, monterey:       "8d8d2dfad3d286e38657b26d96dccce1414b32714d71bf90de29111a164df833"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d8d2dfad3d286e38657b26d96dccce1414b32714d71bf90de29111a164df833"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6591f0f5a8efd02ffb138a7e880782dc55c1548420adc6a9722dc060f0c70dac"
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
