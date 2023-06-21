require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.140.0.tgz"
  sha256 "2fd28c31f4a78e7b75519041013944bfc5fa617801f2060e767d3c8d870e816e"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a18d03e5146870b6bb75c2e2d53b8326d3c3d6108b83227207445f3951a80d05"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cb01dd9fe940574f9c765a8ada05225d8adbe478bcf97abdf28f44cc37dd51a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "750b8480ba0a22a83b47cdc21af004e7a14f22aa65c5dd5d11199f8870245f39"
    sha256 cellar: :any_skip_relocation, ventura:        "a9bbfea2ddb2d178cf2074c56bf3371aa44b44540303be4ab862b17cbe9a8c97"
    sha256 cellar: :any_skip_relocation, monterey:       "b16a650d8678166a1794fc607ad6e6a683a32f7d1e9571a0323777bbc8802ba3"
    sha256 cellar: :any_skip_relocation, big_sur:        "418791f7491de05e5ed88e4e17364139087770306f33cf4435eacf0f197f4fa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc76348354a9b805f505113212b1135a68b32aed82c2fd25bd3d426abe596c44"
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
