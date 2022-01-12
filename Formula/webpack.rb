require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.66.0.tgz"
  sha256 "d9706890afb18c6b9fa5c361254f7a9e546ee1f4fc9f49dcb2e7f8afd91785c3"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53f67a0ca1f261d045038b489bb094588092011bc7462cf66da3afaef85f8576"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53f67a0ca1f261d045038b489bb094588092011bc7462cf66da3afaef85f8576"
    sha256 cellar: :any_skip_relocation, monterey:       "4b1ae30250eadcc2a45d3324cdb3e7cdc195187435486699652dd562cda4b0d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b1ae30250eadcc2a45d3324cdb3e7cdc195187435486699652dd562cda4b0d0"
    sha256 cellar: :any_skip_relocation, catalina:       "4b1ae30250eadcc2a45d3324cdb3e7cdc195187435486699652dd562cda4b0d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cded645311fe1bef221a824fd54af7e7c5fa04bdc3023085f18e1d718405b4f"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-4.9.1.tgz"
    sha256 "0e80f38d28019f7c30f7237ca0b7a250dfe0b561d07d8248b162dde663cd54ff"
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
    assert_match "const e=document\.createElement(\"div\");", File.read(testpath/"dist/main.js")
  end
end
