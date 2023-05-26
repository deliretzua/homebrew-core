require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.22.0.tgz"
  sha256 "52c4586380d0654bf2e824f8002b0c1e3c23b9ce526db1a8aff9f1a6dd14666b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80ae50c154022611f90201dca5f03ef61badd73b0e20a1893c4a9132fc2a2050"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80ae50c154022611f90201dca5f03ef61badd73b0e20a1893c4a9132fc2a2050"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "80ae50c154022611f90201dca5f03ef61badd73b0e20a1893c4a9132fc2a2050"
    sha256 cellar: :any_skip_relocation, ventura:        "80ae50c154022611f90201dca5f03ef61badd73b0e20a1893c4a9132fc2a2050"
    sha256 cellar: :any_skip_relocation, monterey:       "80ae50c154022611f90201dca5f03ef61badd73b0e20a1893c4a9132fc2a2050"
    sha256 cellar: :any_skip_relocation, big_sur:        "80ae50c154022611f90201dca5f03ef61badd73b0e20a1893c4a9132fc2a2050"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1b8d809a81d00d1ed1dd9991f89785e200523a87b5b3dbbf8388733d54e2ab5"
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
