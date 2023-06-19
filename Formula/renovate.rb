require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.132.0.tgz"
  sha256 "857ef607c803ee02d55515a0df9023476030d85d7605a99f898544a1d4b75de2"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b889660c9df713f8db2617cfea4a187c1ce8683a1a6361f3e21ce0e3e21427a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "459f48ceee5aa6674b3ec14ee43ef01db0719e3be84ca810029e7b99b2eff094"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc0514ba5a40cc1ecc446044161c85fae163d383c5fc20d8233cd927df5c2248"
    sha256 cellar: :any_skip_relocation, ventura:        "ed4af7b6a33efb9d560d186731857467401195411d813c347dc2499fa2f5f2fb"
    sha256 cellar: :any_skip_relocation, monterey:       "ea56fce00287b5893090e9027586ad826cb4bf76b04feb9fb2a53755e56d5ebc"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c8aaf105d5bc1749ad89401a709f422d34ac39531b2010b1a57643ba7828136"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a28e2ecd838164dd009307ec84f286f9fd757de293afbfd26509b47c8c7025d8"
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
