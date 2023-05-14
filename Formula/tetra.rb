class Tetra < Formula
  desc "Tetragon CLI to observe, manage and troubleshoot Tetragon instances"
  homepage "https://github.com/cilium/tetragon"
  url "https://github.com/cilium/tetragon/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "4d6c08d00f13e5d886bf6800a9c978e578f25bc865fa42ef2f05aae6920c6150"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5631195aaacbab0ae96f0a73db7a2a1f014b03f8575861b71cf7a090a78117b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5631195aaacbab0ae96f0a73db7a2a1f014b03f8575861b71cf7a090a78117b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5631195aaacbab0ae96f0a73db7a2a1f014b03f8575861b71cf7a090a78117b9"
    sha256 cellar: :any_skip_relocation, ventura:        "c02cecd0a76c732d2d88f6cb5f1e197218b47007af096d0dbbd394318e605398"
    sha256 cellar: :any_skip_relocation, monterey:       "c02cecd0a76c732d2d88f6cb5f1e197218b47007af096d0dbbd394318e605398"
    sha256 cellar: :any_skip_relocation, big_sur:        "c02cecd0a76c732d2d88f6cb5f1e197218b47007af096d0dbbd394318e605398"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb0b6ca7146cf81b779a355e36b2b94328c22f39276446252abd188c7edd3fe3"
  end

  depends_on "go" => :build

  # Build patch for OS compatibility, remove in next release
  patch do
    url "https://github.com/cilium/tetragon/commit/09809a686482f83047f44fc921363822893b0967.patch?full_index=1"
    sha256 "46fa04a794d8f0325caeac47ef7e787d3c31e233c4841c4a5f47791cee0c00ef"
  end

  def install
    # remove patched empty files, remove in next release
    rm_f ["cmd/tetra/full_commands.go", "cmd/tetra/standalone_commands.go"]
    ldflags = "-s -w -X github.com/cilium/tetragon/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"tetra"), "./cmd/tetra"

    generate_completions_from_executable(bin/"tetra", "completion")
  end

  test do
    assert_match "cli version: #{version}", shell_output("#{bin}/tetra version --client")
    assert_match "{}", pipe_output("#{bin}/tetra getevents", "invalid_event")
  end
end
