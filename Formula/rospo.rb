class Rospo < Formula
  desc "🐸 Simple, reliable, persistent ssh tunnels with embedded ssh server"
  homepage "https://github.com/ferama/rospo"
  url "https://github.com/ferama/rospo/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "33b2f9f31741cabdee8d96bf7bcd3b14d7ba120f02873fe31d2d3622131f0fef"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "104ce7a087efd2736e8448fed379c146a16d87b62aaa56cfff5e167266ae8a08"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "104ce7a087efd2736e8448fed379c146a16d87b62aaa56cfff5e167266ae8a08"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "104ce7a087efd2736e8448fed379c146a16d87b62aaa56cfff5e167266ae8a08"
    sha256 cellar: :any_skip_relocation, ventura:        "ac1495179a21108df003351b3bd8c3bd3adc4310bdfcc10b0e3636a057f2977b"
    sha256 cellar: :any_skip_relocation, monterey:       "ac1495179a21108df003351b3bd8c3bd3adc4310bdfcc10b0e3636a057f2977b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac1495179a21108df003351b3bd8c3bd3adc4310bdfcc10b0e3636a057f2977b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbbbe6db80c83d80f48fc69bc24a3bfbc707756d25f79e197758a4ca1549f6b1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X 'github.com/ferama/rospo/cmd.Version=#{version}'")

    generate_completions_from_executable(bin/"rospo", "completion")
  end

  test do
    system bin/"rospo", "-v"
    system bin/"rospo", "keygen", "-s"
    assert_predicate testpath/"identity", :exist?
    assert_predicate testpath/"identity.pub", :exist?
  end
end
