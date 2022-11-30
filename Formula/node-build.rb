class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/v4.9.100.tar.gz"
  sha256 "9b3b9aab011b2ecc50a922684c64eebfff0f8bcdf6c4b56d8a0a4bf59a2793d6"
  license "MIT"
  head "https://github.com/nodenv/node-build.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "47d2665c4c7c657496f56618f6125aba503b89c11c868adafe89fd3ca9dfa81f"
  end

  depends_on "autoconf"
  depends_on "openssl@1.1"
  depends_on "pkg-config"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    system "#{bin}/node-build", "--definitions"
  end
end
