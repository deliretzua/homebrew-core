class Bittwist < Formula
  desc "Libcap-based Ethernet packet generator"
  homepage "https://bittwist.sourceforge.io"
  url "https://downloads.sourceforge.net/project/bittwist/macOS/Bit-Twist%203.4/bittwist-macos-3.4.tar.gz"
  sha256 "e3347164c99354920b10d2005a217148781f85a6753e6a4ceec2f8d1097a635d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "725817e2a6f0f0a55d06b97230cff167546624bba12cf8aca5a44a1b8220c0fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5561fb88c0b0e7c8fb5d68812b6e9ff168212d9f833653bc3188e79f1b429502"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4d079f3b872e521fa4d585c8b562a95e05ec7538aad5301fc3462b7a26f65a2"
    sha256 cellar: :any_skip_relocation, ventura:        "e56035b202c224e6becf2a67ca869ba86e596e2cb9ef186f538627290518a142"
    sha256 cellar: :any_skip_relocation, monterey:       "3e4dec3f83e9fa88a7c254d88222fa97e1dd4640380665f5e176f1bd72634f61"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9999f88ba29acc3e98c4e09a2477b27c6dd5d06fb543f1b0c79e830429d1bb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ee3b8ff7a895bc90c8a8b56be28170d16a5444cfd918d5fcf1869a7c6915be6"
  end

  uses_from_macos "libpcap"

  def install
    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/bittwist", "-help"
    system "#{bin}/bittwiste", "-help"
  end
end
