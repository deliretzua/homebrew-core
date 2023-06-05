require "language/node"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-15.11.0.tgz"
  sha256 "94cdce80b17ec69604d226292124fb06e2592ed861265c971fb642732ac14204"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee030f65c4061ac579da1f39854cb4cc69a8ef2f67edd00a505fda546ce7a073"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee030f65c4061ac579da1f39854cb4cc69a8ef2f67edd00a505fda546ce7a073"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee030f65c4061ac579da1f39854cb4cc69a8ef2f67edd00a505fda546ce7a073"
    sha256 cellar: :any_skip_relocation, ventura:        "092dfc5c60337ab87c70adb01c7813e58c5243645cd72932a57e5caa551bc631"
    sha256 cellar: :any_skip_relocation, monterey:       "092dfc5c60337ab87c70adb01c7813e58c5243645cd72932a57e5caa551bc631"
    sha256 cellar: :any_skip_relocation, big_sur:        "092dfc5c60337ab87c70adb01c7813e58c5243645cd72932a57e5caa551bc631"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee030f65c4061ac579da1f39854cb4cc69a8ef2f67edd00a505fda546ce7a073"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/release-it -v")
    (testpath/"package.json").write("{\"name\":\"test-pkg\",\"version\":\"1.0.0\"}")
    assert_match(/Let's release test-pkg.+\(1\.0\.0\.\.\.1\.0\.1\).+Empty changelog.+Done \(in \d+s\.\)/m,
      shell_output("#{bin}/release-it --npm.skipChecks --no-npm.publish --ci"))
    assert_match "1.0.1", (testpath/"package.json").read
  end
end
