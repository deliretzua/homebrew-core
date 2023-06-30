require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.82.tgz"
  sha256 "21d9eeccd1e039b8f58e15d3a7746aae3a3f2942a0983eabec24ecd03d0b0732"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78c53d1d6046c330481a64ac1b40eaf2d023ae9b8a8adca0f0d3e41a64754122"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17cec4e1dcc96c8fb9c86a05543ce833b5e426ad42c869a7e8f1569f50fe9633"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17cec4e1dcc96c8fb9c86a05543ce833b5e426ad42c869a7e8f1569f50fe9633"
    sha256 cellar: :any_skip_relocation, ventura:        "b86147da76fb136d8a64eef162c645037f26f53f26b9ed281b349227c4bab846"
    sha256 cellar: :any_skip_relocation, monterey:       "b86147da76fb136d8a64eef162c645037f26f53f26b9ed281b349227c4bab846"
    sha256 cellar: :any_skip_relocation, big_sur:        "b86147da76fb136d8a64eef162c645037f26f53f26b9ed281b349227c4bab846"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57e0113afb027ca073c311e69ced46acacb3b5f9ea8fb20bf58fa301961e3b32"
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
