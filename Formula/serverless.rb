require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.30.1.tar.gz"
  sha256 "b75f16dd62faa348a0e082e62bd70ac8a9ef64179ff83c1f5bccc87b2a222a51"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d31cfaf7bf47ae14969ae64ed5d507779c62258979cace7f6484389df32c4d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d31cfaf7bf47ae14969ae64ed5d507779c62258979cace7f6484389df32c4d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d31cfaf7bf47ae14969ae64ed5d507779c62258979cace7f6484389df32c4d8"
    sha256 cellar: :any_skip_relocation, ventura:        "a1ea12dd84244cadf289938dc2dd36510fa6125bafecd29a3a64b33e7e4836fc"
    sha256 cellar: :any_skip_relocation, monterey:       "a1ea12dd84244cadf289938dc2dd36510fa6125bafecd29a3a64b33e7e4836fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1ea12dd84244cadf289938dc2dd36510fa6125bafecd29a3a64b33e7e4836fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1ac4f4a3f2c14f749b63dc07eb3f9acf13ca8f3421a90041cb975d6dc0b44af"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]

    # Delete incompatible Linux CPython shared library included in dependency package.
    # Raise an error if no longer found so that the unused logic can be removed.
    (libexec/"lib/node_modules/serverless/node_modules/@serverless/dashboard-plugin")
      .glob("sdk-py/serverless_sdk/vendor/wrapt/_wrappers.cpython-*-linux-gnu.so")
      .map(&:unlink)
      .empty? && raise("Unable to find wrapt shared library to delete.")

    # Replace universal binaries with their native slices
    deuniversalize_machos libexec/"lib/node_modules/serverless/node_modules/fsevents/fsevents.node"
  end

  test do
    (testpath/"serverless.yml").write <<~EOS
      service: homebrew-test
      provider:
        name: aws
        runtime: python3.6
        stage: dev
        region: eu-west-1
    EOS

    system("#{bin}/serverless", "config", "credentials", "--provider", "aws", "--key", "aa", "--secret", "xx")
    output = shell_output("#{bin}/serverless package 2>&1")
    assert_match "Packaging homebrew-test for stage dev", output
  end
end
