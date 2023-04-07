require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.32.21.tgz"
  sha256 "6562d02875944036e8a2191f2bb99b79fabf7e9bbce158deb1962a530ee89a93"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24602816409d37c9eaffb83c577d5fd64ea2ef136ca3129455ffbe5c9aa2add2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24602816409d37c9eaffb83c577d5fd64ea2ef136ca3129455ffbe5c9aa2add2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24602816409d37c9eaffb83c577d5fd64ea2ef136ca3129455ffbe5c9aa2add2"
    sha256 cellar: :any_skip_relocation, ventura:        "b1b7069378deebfd2e29ef146622a64a8d7a0287f17161a63525654e3ed5c577"
    sha256 cellar: :any_skip_relocation, monterey:       "b1b7069378deebfd2e29ef146622a64a8d7a0287f17161a63525654e3ed5c577"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1b7069378deebfd2e29ef146622a64a8d7a0287f17161a63525654e3ed5c577"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24602816409d37c9eaffb83c577d5fd64ea2ef136ca3129455ffbe5c9aa2add2"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
