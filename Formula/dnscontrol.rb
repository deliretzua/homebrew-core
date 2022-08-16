class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v3.19.0.tar.gz"
  sha256 "1b51c1b47ce8119525116d34cca71aeb75d268869dd3dc18668168c7186611fb"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5e058e673e77c988e048a218d274564f85e45754655d59900be8afe0d0d0f8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b67640cfffdd880b3ffc755d0141798fd7a2849ea3c319b9c88cc12a4b3caabe"
    sha256 cellar: :any_skip_relocation, monterey:       "c93d92c10f3d0702db65003f986adcf8431df5754a858f6b891694f2efbf26f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "2fa51f904d164f8fcbc2254c2d907c06c7aeb98009d09362dfb7d5974a0771f2"
    sha256 cellar: :any_skip_relocation, catalina:       "49f0a904ac2e2d1a5b1efc9973904718429bdc45f24c4b345edcb86b9fc90753"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd0e33ef3286d96eed719b93de3892858cef59ae13345f0f7c44d710eefc3d28"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"dnsconfig.js").write <<~EOS
      var namecom = NewRegistrar("name.com", "NAMEDOTCOM");
      var r53 = NewDnsProvider("r53", "ROUTE53")

      D("example.com", namecom, DnsProvider(r53),
        A("@", "1.2.3.4"),
        CNAME("www","@"),
        MX("@",5,"mail.myserver.com."),
        A("test", "5.6.7.8")
      )
    EOS

    output = shell_output("#{bin}/dnscontrol check #{testpath}/dnsconfig.js 2>&1").strip
    assert_equal "No errors.", output
  end
end
