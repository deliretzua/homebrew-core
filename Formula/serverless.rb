require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.32.1.tar.gz"
  sha256 "05c98e4e2d2bd8c5aaa2d7475afc4e40d8f79a3f75d961187e5fe74ad5f32983"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba999b18cb4d814c72a7caa16bf40adb2a51191eb5e633ab787f85d350723698"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba999b18cb4d814c72a7caa16bf40adb2a51191eb5e633ab787f85d350723698"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba999b18cb4d814c72a7caa16bf40adb2a51191eb5e633ab787f85d350723698"
    sha256 cellar: :any_skip_relocation, ventura:        "be92cf3c13a0a23420cf97b34253231589cbdfa015878ecae8cf787f40f81e77"
    sha256 cellar: :any_skip_relocation, monterey:       "be92cf3c13a0a23420cf97b34253231589cbdfa015878ecae8cf787f40f81e77"
    sha256 cellar: :any_skip_relocation, big_sur:        "be92cf3c13a0a23420cf97b34253231589cbdfa015878ecae8cf787f40f81e77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c3ed1b9445a1e731e22c93c966358b63487bb9807d3149ab42c14e6fa774755"
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
