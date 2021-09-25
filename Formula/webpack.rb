require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.54.0.tgz"
  sha256 "5fc272acee5eabac93aba48257edb529180c2afb8a55e7f1a117315fa8db205a"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "00962f5736f1ee6dd80bfd8ba0ca4ee31a8d54c17b9888f2ac13e090aec08b6d"
    sha256 cellar: :any_skip_relocation, big_sur:       "4889ff4b671fe59c0acf3f622c2e31e2540c28c7803d2477de40e24d91c51389"
    sha256 cellar: :any_skip_relocation, catalina:      "4889ff4b671fe59c0acf3f622c2e31e2540c28c7803d2477de40e24d91c51389"
    sha256 cellar: :any_skip_relocation, mojave:        "4889ff4b671fe59c0acf3f622c2e31e2540c28c7803d2477de40e24d91c51389"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f135a195155399576eacbb072ca6405818121b72567102c0a66c12203dc33ff"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-4.8.0.tgz"
    sha256 "013b570d1ae071834ba7552b2bb6b00c4bd467d417b7623ed55a0ce909c1705e"
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
