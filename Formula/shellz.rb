class Shellz < Formula
  desc "Small utility to track and control custom shellz"
  homepage "https://github.com/evilsocket/shellz"
  url "https://github.com/evilsocket/shellz/archive/v1.5.1.tar.gz"
  sha256 "ff7d5838fd0f8385a700bd882eab9f6e5da023899458c9215e36e2244cc11bfd"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:     "901aa899dffdce56b40da9b622acd01acb15103cbae6d06cb35320fc85ffa626"
    sha256 cellar: :any_skip_relocation, catalina:    "1c1eabfee3228f25f75b4838f3d0a8a49e84c87eb2926e78cdf05dff094aa0e8"
    sha256 cellar: :any_skip_relocation, mojave:      "aa5043471c26fba80ba9db128f5ff3e8b60051bd76a8d26c3ad114b59b24c8b3"
    sha256 cellar: :any_skip_relocation, high_sierra: "83b7e5e52243efe75e302853574243667a8e9cf9899d480c12c27886e77a9788"
    sha256 cellar: :any_skip_relocation, sierra:      "b659a90bd79e516d71679e68d36a35038937f23ee9d1de1dfee313fd11b0169e"
  end

  depends_on "go" => :build

  # remove in next release
  patch do
    url "https://github.com/chenrui333/shellz/commit/10bd430.patch?full_index=1"
    sha256 "c23d375e7ea2b20e3c2c0fec39adda384a0ce34482c7d97f8aa63c1526bf80f3"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/shellz"
  end

  test do
    output = shell_output("#{bin}/shellz -no-banner -no-effects -path #{testpath}", 1)
    assert_match "creating", output
    assert_predicate testpath/"shells", :exist?
  end
end
