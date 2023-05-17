require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.22.0.tgz"
  sha256 "570a3edf624fdbd4bd1be5729e4629e7a3a89a1235994aff731ca9a7c875dc02"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68f5e60890d88b300354211145d9f39a4f05c2ffe5b23b80177a798a09aa7106"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68f5e60890d88b300354211145d9f39a4f05c2ffe5b23b80177a798a09aa7106"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68f5e60890d88b300354211145d9f39a4f05c2ffe5b23b80177a798a09aa7106"
    sha256 cellar: :any_skip_relocation, ventura:        "36af6c479b9088183a7feb37a2535f25bc4e46c96b79dd158ae989c2ce6fc045"
    sha256 cellar: :any_skip_relocation, monterey:       "36af6c479b9088183a7feb37a2535f25bc4e46c96b79dd158ae989c2ce6fc045"
    sha256 cellar: :any_skip_relocation, big_sur:        "36af6c479b9088183a7feb37a2535f25bc4e46c96b79dd158ae989c2ce6fc045"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c99170083903ee308f534829b5fd064e08ac0ea1f38e223971d0320d230d5a03"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    deuniversalize_machos
  end

  test do
    (testpath/"test/main.js").write <<~EOS
      import foo from './foo.js';
      export default function () {
        console.log(foo);
      }
    EOS

    (testpath/"test/foo.js").write <<~EOS
      export default 'hello world!';
    EOS

    expected = <<~EOS
      'use strict';

      var foo = 'hello world!';

      function main () {
        console.log(foo);
      }

      module.exports = main;
    EOS

    assert_equal expected, shell_output("#{bin}/rollup #{testpath}/test/main.js -f cjs")
  end
end
