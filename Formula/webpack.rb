require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.81.0.tgz"
  sha256 "92150195349d85360a97d0819143e567bcd38c5c39bdca9a2cd84769fc7db526"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ace9df6c71768ff05234c5c37ef58972f4864b9868e2354e2fef270b5233603a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ace9df6c71768ff05234c5c37ef58972f4864b9868e2354e2fef270b5233603a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ace9df6c71768ff05234c5c37ef58972f4864b9868e2354e2fef270b5233603a"
    sha256 cellar: :any_skip_relocation, ventura:        "6cf7e89e75de750965b67c8d614bbe182f43cc8e0ada271f0d7e758754a36595"
    sha256 cellar: :any_skip_relocation, monterey:       "6cf7e89e75de750965b67c8d614bbe182f43cc8e0ada271f0d7e758754a36595"
    sha256 cellar: :any_skip_relocation, big_sur:        "6cf7e89e75de750965b67c8d614bbe182f43cc8e0ada271f0d7e758754a36595"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ace9df6c71768ff05234c5c37ef58972f4864b9868e2354e2fef270b5233603a"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-5.0.2.tgz"
    sha256 "0a213a48cf35b4c4a6144c36ab964a86a1f15bede4b96b999b6be3c7efbb7279"
  end

  def install
    (buildpath/"node_modules/webpack").install Dir["*"]
    buildpath.install resource("webpack-cli")

    cd buildpath/"node_modules/webpack" do
      system "npm", "install", *Language::Node.local_npm_install_args, "--legacy-peer-deps"
    end

    # declare webpack as a bundledDependency of webpack-cli
    pkg_json = JSON.parse(File.read("package.json"))
    pkg_json["dependencies"]["webpack"] = version
    pkg_json["bundleDependencies"] = ["webpack"]
    File.write("package.json", JSON.pretty_generate(pkg_json))

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)

    bin.install_symlink libexec/"bin/webpack-cli"
    bin.install_symlink libexec/"bin/webpack-cli" => "webpack"

    # Replace universal binaries with their native slices
    deuniversalize_machos
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
    assert_match "const e=document.createElement(\"div\");", File.read(testpath/"dist/main.js")
  end
end
