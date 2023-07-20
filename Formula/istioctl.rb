class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio/archive/refs/tags/1.18.1.tar.gz"
  sha256 "3ca4370fa94df4704ed4350e998c177abe83aff24eabbcf9d9bb6619961bcace"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47efcb9d2bf4d65f11ad38f7bf8c9d5264825d39f17d3276f8db48df30662af4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47efcb9d2bf4d65f11ad38f7bf8c9d5264825d39f17d3276f8db48df30662af4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47efcb9d2bf4d65f11ad38f7bf8c9d5264825d39f17d3276f8db48df30662af4"
    sha256 cellar: :any_skip_relocation, ventura:        "0a12321eb2f5442b53cc9727745ca4a53141ae136dd836359bcea8c6f7d8548f"
    sha256 cellar: :any_skip_relocation, monterey:       "0a12321eb2f5442b53cc9727745ca4a53141ae136dd836359bcea8c6f7d8548f"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a12321eb2f5442b53cc9727745ca4a53141ae136dd836359bcea8c6f7d8548f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4dbd7e96569b73df3b74baf39a87ad0b10981424ff97fbdc9868411d9345e566"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X istio.io/pkg/version.buildVersion=#{version}
      -X istio.io/pkg/version.buildStatus=#{tap.user}
      -X istio.io/pkg/version.buildTag=#{version}
      -X istio.io/pkg/version.buildHub=docker.io/istio
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./istioctl/cmd/istioctl"

    generate_completions_from_executable(bin/"istioctl", "completion")
    system bin/"istioctl", "collateral", "--man"
    man1.install Dir["*.1"]
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/istioctl version --remote=false").strip
  end
end
