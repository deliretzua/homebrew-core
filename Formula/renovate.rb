require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.91.0.tgz"
  sha256 "aa72d9c09cded4dfac7515878ac18e6d5dd410e5afa778c29a0b121b9ee271f8"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https://registry.npmjs.org/renovate/latest"
    regex(/v?(\d+(?:\.\d+)+)/i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256                               arm64_ventura:  "a0389d1d75fbdf34b1178baa67ece0aaa820567d15dc8d1344d13607a731501b"
    sha256                               arm64_monterey: "095994b94b877b5ebaf6973812d434604c40020a61175ffbb66e3a5f9d4e4312"
    sha256                               arm64_big_sur:  "cdda57651ec181f3adcdbc3953d1058c694300365ff9401132714f3cd3e50f8b"
    sha256                               ventura:        "8904aa69fc8904934943b21d7d81255117cf2bdfd45a2a23f506c6ec3e4e0ee7"
    sha256                               monterey:       "08d1232ac3a0de2d2f90ca402b15da4b4d5018ecc28bc7fc1f1fcfe274d44516"
    sha256                               big_sur:        "70ff39d85df357ae60f94f04d732665fb86389094d17d2170dbcfc68be9329d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f97ae634302f72e9be3d66e8df009cd70ca2354620e1b94bcba112585355f64b"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end
