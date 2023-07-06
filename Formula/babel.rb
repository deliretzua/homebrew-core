require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.22.8.tgz"
  sha256 "0a76c75ebe3c47235d4c7f9f1855ac0660bf5d43a25f7bf43728d887b0b8dfba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "832521e6315f46a7f1cd7869393359df1a68e99c809185bad5feb5c437989c60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "832521e6315f46a7f1cd7869393359df1a68e99c809185bad5feb5c437989c60"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "832521e6315f46a7f1cd7869393359df1a68e99c809185bad5feb5c437989c60"
    sha256 cellar: :any_skip_relocation, ventura:        "832521e6315f46a7f1cd7869393359df1a68e99c809185bad5feb5c437989c60"
    sha256 cellar: :any_skip_relocation, monterey:       "832521e6315f46a7f1cd7869393359df1a68e99c809185bad5feb5c437989c60"
    sha256 cellar: :any_skip_relocation, big_sur:        "832521e6315f46a7f1cd7869393359df1a68e99c809185bad5feb5c437989c60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe07ffad02846e5eed87fa409eab163ca47f72b8da0fe914583b3ab0cf50abc2"
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.22.6.tgz"
    sha256 "0a078845e29db377e71a42275524a5ad62bbf82626b6b05616261cf7b8a7935d"
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
