class Tetra < Formula
  desc "Tetragon CLI to observe, manage and troubleshoot Tetragon instances"
  homepage "https://github.com/cilium/tetragon"
  url "https://github.com/cilium/tetragon/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "99cc4e82367eb4ad12dc5d8b710e609f10e7950280f510ea3884caf814f8bab1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f39cf86d37ec1e54b9d1d582a4283edeb1a23218566fafc89ea3bd74a8e7e0dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f39cf86d37ec1e54b9d1d582a4283edeb1a23218566fafc89ea3bd74a8e7e0dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f39cf86d37ec1e54b9d1d582a4283edeb1a23218566fafc89ea3bd74a8e7e0dd"
    sha256 cellar: :any_skip_relocation, ventura:        "e4a0e7a634b9efc8b81a12dd16c6ac00bb28506549131d184dfb5881f354b215"
    sha256 cellar: :any_skip_relocation, monterey:       "e4a0e7a634b9efc8b81a12dd16c6ac00bb28506549131d184dfb5881f354b215"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4a0e7a634b9efc8b81a12dd16c6ac00bb28506549131d184dfb5881f354b215"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4baa3a79527029920fe717ccc7a1b11d8da6093129c7132f8afe45ee3d4f208c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/tetragon/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"tetra"), "./cmd/tetra"

    generate_completions_from_executable(bin/"tetra", "completion")
  end

  test do
    assert_match "cli version: #{version}", shell_output("#{bin}/tetra version --client")
    assert_match "{}", pipe_output("#{bin}/tetra getevents", "invalid_event")
  end
end
