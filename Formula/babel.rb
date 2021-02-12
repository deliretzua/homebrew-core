require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.12.16.tgz"
  sha256 "407b393b5e00eecf5f597665815fd196395479958f18be218a932374aa339d12"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a684f98d0ed4c1adf6669a487c4bf71079ddf1c54a570428cd3735efe3e61de1"
    sha256 cellar: :any_skip_relocation, big_sur:       "4f0b2ad420c5ff95f195069c636fcc944798750e6fcb25da012416a06cc58446"
    sha256 cellar: :any_skip_relocation, catalina:      "224a93d17b4abde502240010d677a7555fef309dc544f9dffdf33d18e89f819a"
    sha256 cellar: :any_skip_relocation, mojave:        "274dfed809cf8b3b9eaf17bbb3c3efa319ca529eb316b41a3811c6291ac2c3d4"
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.12.16.tgz"
    sha256 "76371894db1fcc1da9f3ced098b2d6112240cbb535cffaff8a1f10417f205799"
  end

  def install
    (buildpath/"node_modules/@babel/core").install Dir["*"]
    buildpath.install resource("babel-cli")

    cd buildpath/"node_modules/@babel/core" do
      system "npm", "install", *Language::Node.local_npm_install_args, "--production"
    end

    # declare babel-core as a bundledDependency of babel-cli
    pkg_json = JSON.parse(IO.read("package.json"))
    pkg_json["dependencies"]["@babel/core"] = version
    pkg_json["bundleDependencies"] = ["@babel/core"]
    IO.write("package.json", JSON.pretty_generate(pkg_json))

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
