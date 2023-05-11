require "language/node"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.35.tgz"
  sha256 "7b233de08f4693c713ab1b3a2d840895ad750df17778b212bd91c74a87236f2d"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_ventura:  "f7b12a79299391a5295f025dadc874c354f9a9d467af6706042b1ff2464829b5"
    sha256                               arm64_monterey: "14d32588521fb01b1e8952bc900420e2b9c7b117af644368bef797e8e8ea41df"
    sha256                               arm64_big_sur:  "64a97ded1492783489382b021b94587b1d9eb26af2919b3365aa358892922bc4"
    sha256                               ventura:        "beff25958ceb4a8f83811cb6851c398bb1f4c4656d6e3497ac92d724a57cf7bb"
    sha256                               monterey:       "7aab89d459bf5d9eedb038079d875a1312d23c35e4a643e3fc80f610f6106cef"
    sha256                               big_sur:        "b8152e7392d0ae2ed505cabc26478ef0d2dea715a514d9246f7141051f4ec344"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdf33003d82487acb6c6f7b42297c27faa8e8c1ed08177ced9dea8264d9b7dd5"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "node"

  on_linux do
    depends_on "libsecret"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def caveats
    <<~EOS
      This formula only installs the command-line utilities by default.

      Install Leapp.app with Homebrew Cask:
        brew install --cask leapp
    EOS
  end

  test do
    assert_match "Leapp app must be running to use this CLI",
      shell_output("#{bin}/leapp idp-url create --idpUrl https://example.com 2>&1", 2).strip
  end
end
