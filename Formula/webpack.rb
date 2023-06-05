require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.85.1.tgz"
  sha256 "c7c30fd35758c7fb2565635f33370fc38b1a8cf95eea8fa2e0427805b7c8e4db"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34531db69badff005eb8911c8e5ede05a9c954139c5d5dfd8b0b13661b6bd107"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34531db69badff005eb8911c8e5ede05a9c954139c5d5dfd8b0b13661b6bd107"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34531db69badff005eb8911c8e5ede05a9c954139c5d5dfd8b0b13661b6bd107"
    sha256 cellar: :any_skip_relocation, ventura:        "d5e03ab2726a36fa9f0a26936bf1a0139aa29b4f9b08489e09d0dc9abd1e7ab1"
    sha256 cellar: :any_skip_relocation, monterey:       "d5e03ab2726a36fa9f0a26936bf1a0139aa29b4f9b08489e09d0dc9abd1e7ab1"
    sha256 cellar: :any_skip_relocation, big_sur:        "d5e03ab2726a36fa9f0a26936bf1a0139aa29b4f9b08489e09d0dc9abd1e7ab1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34531db69badff005eb8911c8e5ede05a9c954139c5d5dfd8b0b13661b6bd107"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-5.1.3.tgz"
    sha256 "0f814cfa5fce08b19d47dcfa535ed4f44fbadb2bcafd3fe0b8a7b2481b4b4065"
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
