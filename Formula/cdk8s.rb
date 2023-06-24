require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.73.tgz"
  sha256 "4b7a3bba31ec2470e7727490574bf8b8743049adc443b32ad7651d0c66edafc6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98cd849fec3bb958aef8ab09492f8005c1945009eaf28bc3fb88e7aca3b7457f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98cd849fec3bb958aef8ab09492f8005c1945009eaf28bc3fb88e7aca3b7457f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "98cd849fec3bb958aef8ab09492f8005c1945009eaf28bc3fb88e7aca3b7457f"
    sha256 cellar: :any_skip_relocation, ventura:        "ffa54498f51dccd4379f128d6f7cbb24428107734f4b9635cdb9f524826c482f"
    sha256 cellar: :any_skip_relocation, monterey:       "ffa54498f51dccd4379f128d6f7cbb24428107734f4b9635cdb9f524826c482f"
    sha256 cellar: :any_skip_relocation, big_sur:        "ffa54498f51dccd4379f128d6f7cbb24428107734f4b9635cdb9f524826c482f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98cd849fec3bb958aef8ab09492f8005c1945009eaf28bc3fb88e7aca3b7457f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end
