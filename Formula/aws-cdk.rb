require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.72.0.tgz"
  sha256 "3487ad57a09d07037020dad2d1dc8ce29b22c316a643f2921b3feea95cc8d5b9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f0c046627b3cd9e7739fdef082ead9a81a348744c2db2f7f1d7ebe3c6ec905a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f0c046627b3cd9e7739fdef082ead9a81a348744c2db2f7f1d7ebe3c6ec905a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f0c046627b3cd9e7739fdef082ead9a81a348744c2db2f7f1d7ebe3c6ec905a"
    sha256 cellar: :any_skip_relocation, ventura:        "27a55471dcfcc4d9283fec1f2a6e10538216af02d1e52d5e3193349551241294"
    sha256 cellar: :any_skip_relocation, monterey:       "27a55471dcfcc4d9283fec1f2a6e10538216af02d1e52d5e3193349551241294"
    sha256 cellar: :any_skip_relocation, big_sur:        "27a55471dcfcc4d9283fec1f2a6e10538216af02d1e52d5e3193349551241294"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "316d599638bcf59454597783a51c763e68703819b46bc3250d0cfb4274cb11c4"
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
