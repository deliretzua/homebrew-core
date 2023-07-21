class IpinfoCli < Formula
  desc "Official CLI for the IPinfo IP Address API"
  homepage "https://ipinfo.io/"
  url "https://github.com/ipinfo/cli/archive/ipinfo-3.0.0.tar.gz"
  sha256 "01bc040f85fe464bd2ce09f89804a09bb12d8883a89552996a50545f41e278c4"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^ipinfo[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "172a74c15ca3d448dad48b475d778183f801ee7f173f60348ab53fcccf888cf8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "469b6613d2e36068f8c5bbf8a296e8a458fef840b488300572dda203287fcf61"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5382d18330585b11ba2a5b23dd1d98de9bcb27d933b4552459a4e2b21ec69a04"
    sha256 cellar: :any_skip_relocation, ventura:        "06a584769baff81d4d96b0cc9262688b7802ce3ee7d5f0722e0ae91639e5cce7"
    sha256 cellar: :any_skip_relocation, monterey:       "3c8924772a7c349b4d6c23f045c64a202dc18e271bbbc94af292282cce882dcc"
    sha256 cellar: :any_skip_relocation, big_sur:        "a49a0a2eeab30c95ede41549a022b4ee48bb7ff60a66ad05df057a2d9d972a0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9b85edbe5f17660ce17f3df588edd7f7735435359142452fae907b2787a8ed4"
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
