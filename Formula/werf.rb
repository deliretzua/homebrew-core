class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.220.tar.gz"
  sha256 "2304301c241239a65a33123f2ce6df7d2e2236aea187d8be684bea52581709b0"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0370470eedfb08860891d6aaf6ff6f306032c4f56a08e20cbdfda9b406a0b4da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70697a2a272e0156f428775645c4ed9709d8dcb0ba1ece1446e76a5c37f12926"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e9228c5d1d3245c075cb82eb3d3f0d53cb31da486e165d6ba4b8e855ef2ad3e"
    sha256 cellar: :any_skip_relocation, ventura:        "2296b107f83096345dfa1fcd341093d345c8cbacac5fb14f183bafe7ebb00a0e"
    sha256 cellar: :any_skip_relocation, monterey:       "0e02db4f73e9bbdf468fd1838f5a9aa12619d6c075d1d046f95de637b7ff5557"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b96b4a8cd268e9525d60e96b8d3a5b81513a46f237d385476e2dd331c25e45f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "677b165c85990f9f0aaddf2dc6402f10628b7db5c093f87ec456cec6e32a1bf1"
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
