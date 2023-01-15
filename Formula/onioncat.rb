class Onioncat < Formula
  desc "VPN-adapter that provides location privacy using Tor or I2P"
  homepage "https://www.onioncat.org"
  url "https://github.com/rahra/onioncat/archive/refs/tags/v0.4.7.tar.gz"
  sha256 "cb830cf92e6dfefe593c941d203ee8478a9687a2708d153b0c585ad0c90ce199"
  license "GPL-3.0-only"
  head "https://github.com/rahra/onioncat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d98c497d64308db451fc406bf76b816ee49b70663ce8f44d191aa27cf3d9e2d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71c67f580e84d26eafae2eda4570a2120397eaf4b51ffbbaef460e90acbd6837"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8fe8eac3abd7b2c80d88637337e7fe1aecf4cd7ece7dfeeef358908eb7e34d2f"
    sha256 cellar: :any_skip_relocation, ventura:        "0eee00bd8307e0b28343321cfebdb0b65d4571303272f4fa641c5bcffda7cc82"
    sha256 cellar: :any_skip_relocation, monterey:       "1cae594d41f43082cbaa1ca9f488731b51041ecd9faf6525606bbb81e2b5c23f"
    sha256 cellar: :any_skip_relocation, big_sur:        "8140808aa7baef9ae6f5b3830587974f4bc00216e8a9201ba70b0110ec719494"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a82151f85710fa7a4eeb914861ea12e8739b5b0afa483f34eb1445ae0a728983"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "tor"

  # Fix missing headers remove in next release
  patch do
    url "https://github.com/rahra/onioncat/commit/daaa2efe4222910d1ee1550bfe41579cb7b480de.patch?full_index=1"
    sha256 "a4327cd9b411f7f9019106dfba7205d26f8f8249d726f5b92f0b91944a5ef238"
  end

  def install
    system "autoreconf", "-ifv"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"ocat", "-i", "fncuwbiisyh6ak3i.onion" # convert keybase's address to IPv6 address format
  end
end
