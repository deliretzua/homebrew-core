require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-8.1.0.tgz"
  sha256 "583fb72c36609eb7d62651822ea8c4714c9bb36446ecbc07b64081a8c7df4623"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "893ea7922dd5405a4cc7029a9618ed8bfb5687ccaeef4358c795cff7e0af0460"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "893ea7922dd5405a4cc7029a9618ed8bfb5687ccaeef4358c795cff7e0af0460"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "893ea7922dd5405a4cc7029a9618ed8bfb5687ccaeef4358c795cff7e0af0460"
    sha256 cellar: :any_skip_relocation, ventura:        "01e0a72bc4b2791f194fc3272a35c1093d8c19df6de28e56835db6d710aa7624"
    sha256 cellar: :any_skip_relocation, monterey:       "01e0a72bc4b2791f194fc3272a35c1093d8c19df6de28e56835db6d710aa7624"
    sha256 cellar: :any_skip_relocation, big_sur:        "01e0a72bc4b2791f194fc3272a35c1093d8c19df6de28e56835db6d710aa7624"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "893ea7922dd5405a4cc7029a9618ed8bfb5687ccaeef4358c795cff7e0af0460"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match ":bug:", shell_output("#{bin}/gitmoji --search bug")
  end
end
