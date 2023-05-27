require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.22.1.tgz"
  sha256 "a39777a68ee3ea2c6c7135de9574ea8d893f82799feea07b6201fa3369111b35"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0f9a3dcfeebeaf41ad1bf3214d25d91746e9b5568821d23090a61b6e2165d0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0f9a3dcfeebeaf41ad1bf3214d25d91746e9b5568821d23090a61b6e2165d0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0f9a3dcfeebeaf41ad1bf3214d25d91746e9b5568821d23090a61b6e2165d0d"
    sha256 cellar: :any_skip_relocation, ventura:        "f0f9a3dcfeebeaf41ad1bf3214d25d91746e9b5568821d23090a61b6e2165d0d"
    sha256 cellar: :any_skip_relocation, monterey:       "f0f9a3dcfeebeaf41ad1bf3214d25d91746e9b5568821d23090a61b6e2165d0d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0f9a3dcfeebeaf41ad1bf3214d25d91746e9b5568821d23090a61b6e2165d0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e17b2e093252e868a3b320e6d91ff100e8e5955ed37aa2c73cd22c683eb24492"
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.21.5.tgz"
    sha256 "4a0f15bfaee333504ddebc7a69487fd2fc21bb9d059c81e526f8ae548a2acc85"
  end

  def install
    (buildpath/"node_modules/@babel/core").install Dir["*"]
    buildpath.install resource("babel-cli")

    cd buildpath/"node_modules/@babel/core" do
      system "npm", "install", *Language::Node.local_npm_install_args, "--production"
    end

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"script.js").write <<~EOS
      [1,2,3].map(n => n + 1);
    EOS

    system bin/"babel", "script.js", "--out-file", "script-compiled.js"
    assert_predicate testpath/"script-compiled.js", :exist?, "script-compiled.js was not generated"
  end
end
