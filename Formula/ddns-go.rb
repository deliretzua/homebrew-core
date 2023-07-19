class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v5.4.0.tar.gz"
  sha256 "3055b4a9bed88a7ad954187ddbfeedd46a789758999de5b0fcb9014b5a26aa73"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff10e4baec7514282a3828dbaf2d6b84a140a67d11df93c3e3e56d1b3018642e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff10e4baec7514282a3828dbaf2d6b84a140a67d11df93c3e3e56d1b3018642e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff10e4baec7514282a3828dbaf2d6b84a140a67d11df93c3e3e56d1b3018642e"
    sha256 cellar: :any_skip_relocation, ventura:        "8bc3ab250cbcce23afcfbc0bd4b87abc9887985955091a82ff78369380262298"
    sha256 cellar: :any_skip_relocation, monterey:       "8bc3ab250cbcce23afcfbc0bd4b87abc9887985955091a82ff78369380262298"
    sha256 cellar: :any_skip_relocation, big_sur:        "8bc3ab250cbcce23afcfbc0bd4b87abc9887985955091a82ff78369380262298"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5879953dbaea2e0ed6362d29e4e3a3fc7f905022ae64cea651b49faaca66ae27"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=v#{version}
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ddns-go -v")

    port = free_port
    spawn "#{bin}/ddns-go -l :#{port} -c #{testpath}/ddns-go.yaml"
    sleep 1

    system "curl", "--silent", "localhost:#{port}/clearLog"
    output = shell_output("curl --silent localhost:#{port}/logs")
    assert_equal "[]", output
  end
end
