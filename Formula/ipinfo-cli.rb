class IpinfoCli < Formula
  desc "Official CLI for the IPinfo IP Address API"
  homepage "https://ipinfo.io/"
  url "https://github.com/ipinfo/cli/archive/ipinfo-2.3.0.tar.gz"
  sha256 "6bae92b7af4858093e489ed1b69e8e5f2305e08420cb1b6be230e04b2360d72a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^ipinfo[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "179489afbbe6c996796d5bbf24ce1adcec23cc3cf35c1595c4167e4f2275f65a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f5152a56cdb747a85f4e47ef272883cc0ff463910c516b82e0322726d4cf254"
    sha256 cellar: :any_skip_relocation, monterey:       "60d40752b4856267164b462402a426d32e5177f5950c7361e4418930c6784e9d"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc3dd4206ee248187d6fea48af2d983a339c595d6bdbe35c4c0c8f322243a705"
    sha256 cellar: :any_skip_relocation, catalina:       "8c2d16713a04c990b6c78a771b860d98d84082ff073bd79353c8575a89c3da42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cf3c675141f6ac01c28d4a5b029c02c13d88ad8a60ede3325bc5b6f021e608b"
  end

  depends_on "go" => :build

  conflicts_with "ipinfo", because: "ipinfo and ipinfo-cli install the same binaries"

  def install
    system "./ipinfo/build.sh"
    bin.install "build/ipinfo"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/ipinfo version").chomp
    assert_equal "1.1.1.0\n1.1.1.1\n1.1.1.2\n1.1.1.3\n", `#{bin}/ipinfo prips 1.1.1.1/30`
  end
end
