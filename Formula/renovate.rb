require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.139.0.tgz"
  sha256 "e686464cab0c0607e2dc6e5cbdefc66698ac819bbf7606a5871ff965b96fd908"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e3ad7a4f127c9e5d1fe622422f6c3ee7994f82435e4680c78d3af89d89644d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85c54d65362c24e81341b44bad4ec263c3fb8a5e25f42d66c163db229ce3f097"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59f08148577d4a7a2a516da10d5f3061395fad3e8e6bc7ce52c39996361b93db"
    sha256 cellar: :any_skip_relocation, ventura:        "225d9dc6722eb145fb80f80e28661a38e44ae535c6fb63becabb909bf19daa62"
    sha256 cellar: :any_skip_relocation, monterey:       "15bdd4ee14b193608dc2893ef7360d01787726f4764a684c8ca88ada00f5b66f"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad43ef2b599e6fa1eb3fc4bda1aaa3e441315b46a16a3d05ba036f62a19b566b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "114083c6774fe2d050c66e029ba375a0a39379b65380585deb9ab8aaedc6912f"
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
