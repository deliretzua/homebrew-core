class Countdown < Formula
  desc "Terminal countdown timer"
  homepage "https://github.com/antonmedv/countdown"
  url "https://github.com/antonmedv/countdown/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "695bb6a57d7ba5a700ac16a7676132ee61c786a5e9a1ca774607d6f2ad5f39d7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a2c9d5dbdd8ea55d9d4731b4df40f27e1d1beea7ff141ccb179ce6fbd50d056"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a2c9d5dbdd8ea55d9d4731b4df40f27e1d1beea7ff141ccb179ce6fbd50d056"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a2c9d5dbdd8ea55d9d4731b4df40f27e1d1beea7ff141ccb179ce6fbd50d056"
    sha256 cellar: :any_skip_relocation, monterey:       "40c915f6f73d94d3933f77cb8b7e30365381c2f0d499cc5f3c53283d3244f3d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "40c915f6f73d94d3933f77cb8b7e30365381c2f0d499cc5f3c53283d3244f3d7"
    sha256 cellar: :any_skip_relocation, catalina:       "40c915f6f73d94d3933f77cb8b7e30365381c2f0d499cc5f3c53283d3244f3d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52390eca05c053bcf280d2aed3cc293178472c9ea71c32e729e2e63949518f35"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    pipe_output bin/"countdown", "0m0s"
  end
end
