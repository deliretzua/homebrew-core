require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.47.0.tgz"
  sha256 "243822233a470fadb0f1c39164727211be570d19de5076572375a09f4fde24d5"
  license "MIT"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2af577329e26c1ccec9ae0e88e7ddec63321f8d29fdcf313bf77f8c6f8eb5af0"
    sha256 cellar: :any_skip_relocation, big_sur:       "40c064f55f42cf599ea0e2aa2df693494a51ebd8786b31a5dc5a4d8c9b0875e3"
    sha256 cellar: :any_skip_relocation, catalina:      "40c064f55f42cf599ea0e2aa2df693494a51ebd8786b31a5dc5a4d8c9b0875e3"
    sha256 cellar: :any_skip_relocation, mojave:        "40c064f55f42cf599ea0e2aa2df693494a51ebd8786b31a5dc5a4d8c9b0875e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1319e703b69de462610383bed1effc9d751dd16dedac2a95324391b40d67edfd"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-4.7.2.tgz"
    sha256 "dce6cce3002e13873a36fb2c31034d9df20f4c68e3edecb93b9e4b71d2e32b77"
  end

  def install
    (buildpath/"node_modules/webpack").install Dir["*"]
    buildpath.install resource("webpack-cli")

    cd buildpath/"node_modules/webpack" do
      system "npm", "install", *Language::Node.local_npm_install_args, "--legacy-peer-deps"
    end

    # declare webpack as a bundledDependency of webpack-cli
    pkg_json = JSON.parse(IO.read("package.json"))
    pkg_json["dependencies"]["webpack"] = version
    pkg_json["bundleDependencies"] = ["webpack"]
    IO.write("package.json", JSON.pretty_generate(pkg_json))

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)

    bin.install_symlink libexec/"bin/webpack-cli"
    bin.install_symlink libexec/"bin/webpack-cli" => "webpack"
  end

  test do
    (testpath/"index.js").write <<~EOS
      function component() {
        const element = document.createElement('div');
        element.innerHTML = 'Hello' + ' ' + 'webpack';
        return element;
      }

      document.body.appendChild(component());
    EOS

    system bin/"webpack", "bundle", "--mode", "production", "--entry", testpath/"index.js"
    assert_match "const e=document\.createElement(\"div\");", File.read(testpath/"dist/main.js")
  end
end
