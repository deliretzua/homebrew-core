require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.24.0.tgz"
  sha256 "5da9a2c3726b143843beade173abc95fd2321471d975464383478321029e5ebc"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4e234e53d516be6cbc1c1a647e14af99708cdd3c9189f950ddc403dfedec2aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4e234e53d516be6cbc1c1a647e14af99708cdd3c9189f950ddc403dfedec2aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4e234e53d516be6cbc1c1a647e14af99708cdd3c9189f950ddc403dfedec2aa"
    sha256 cellar: :any_skip_relocation, ventura:        "2178a753347cf3dcea660d9a0af7f6fb8f15bbcd5125c5b8a185d94ced575163"
    sha256 cellar: :any_skip_relocation, monterey:       "2178a753347cf3dcea660d9a0af7f6fb8f15bbcd5125c5b8a185d94ced575163"
    sha256 cellar: :any_skip_relocation, big_sur:        "2178a753347cf3dcea660d9a0af7f6fb8f15bbcd5125c5b8a185d94ced575163"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d1ea5352e46cf91f25c3bd24d9938e226d28117200863b8c11e0e24e88494fd"
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
