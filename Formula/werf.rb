class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.234.tar.gz"
  sha256 "9e9121ee6b77a0b72a1b87397428cd904c3e313f5d327d3dd093b529022e9b4f"
  license "Apache-2.0"
  head "https://github.com/werf/werf.git", branch: "main"

  # This repository has some tagged versions that are higher than the newest
  # stable release (e.g., `v1.5.2`) and the `GithubLatest` strategy is
  # currently necessary to identify the correct latest version.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1460cb05a7b48b89d6a5c822dc6da0a536d0b2a7b63bfc276de6cf7029a9d62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7d6ba76ed78c5bcd25f31e6346e12bd88f3ee05f2afa4a75a4d49c43dac794f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f1dd3d779dee8dfc29267f14ba1216c2fb67bb3534968114264a840615a5684"
    sha256 cellar: :any_skip_relocation, ventura:        "b52c8d2160528d42c09abbd255b31e94c8466709d558ee0b4f4d5d5b5546bb19"
    sha256 cellar: :any_skip_relocation, monterey:       "164c8745b3f7b7fb4ca7a0e7d92c6681ae846abd55170ff7cdbfa49573ebb7a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d04414ab162fe173ec1494a89c3b4da78515b80f495799fc39f6f070cd554e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5569ff1a923f8bbc9123f17b34a3983e4c9b931e0a48d87401d073c511e8b530"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "btrfs-progs"
    depends_on "device-mapper"
  end

  def install
    if OS.linux?
      ldflags = %W[
        -linkmode external
        -extldflags=-static
        -s -w
        -X github.com/werf/werf/pkg/werf.Version=#{version}
      ]
      tags = %w[
        dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp
        osusergo exclude_graphdriver_devicemapper netgo no_devmapper static_build
      ].join(" ")
    else
      ldflags = "-s -w -X github.com/werf/werf/pkg/werf.Version=#{version}"
      tags = "dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp"
    end

    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags, "./cmd/werf"

    generate_completions_from_executable(bin/"werf", "completion")
  end

  test do
    werf_config = testpath/"werf.yaml"
    werf_config.write <<~EOS
      configVersion: 1
      project: quickstart-application
      ---
      image: vote
      dockerfile: Dockerfile
      context: vote
      ---
      image: result
      dockerfile: Dockerfile
      context: result
      ---
      image: worker
      dockerfile: Dockerfile
      context: worker
    EOS

    output = <<~EOS
      - image: vote
      - image: result
      - image: worker
    EOS

    system "git", "init"
    system "git", "add", werf_config
    system "git", "commit", "-m", "Initial commit"

    assert_equal output, shell_output("#{bin}/werf config graph")

    assert_match version.to_s, shell_output("#{bin}/werf version")
  end
end
