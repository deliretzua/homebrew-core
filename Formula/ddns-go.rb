class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v5.4.0.tar.gz"
  sha256 "3055b4a9bed88a7ad954187ddbfeedd46a789758999de5b0fcb9014b5a26aa73"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f647622443653e078c20874f0dd47c4e0e1d187384402177293d5d5252763ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f647622443653e078c20874f0dd47c4e0e1d187384402177293d5d5252763ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f647622443653e078c20874f0dd47c4e0e1d187384402177293d5d5252763ad"
    sha256 cellar: :any_skip_relocation, ventura:        "e7889eaa41341edc886c56045e433eea0247838234ccbe1703ccdfa7923576eb"
    sha256 cellar: :any_skip_relocation, monterey:       "e7889eaa41341edc886c56045e433eea0247838234ccbe1703ccdfa7923576eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7889eaa41341edc886c56045e433eea0247838234ccbe1703ccdfa7923576eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3555d99be7f8620e6f87eeaaff0ac644ddc96b9c5186600fc83da80a38fb99a8"
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
