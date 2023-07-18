class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.247.tar.gz"
  sha256 "3b01c2f79a9966183d443d936e921c9272b340ff6ab1b2992788b6757201a402"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ca613d4b2b7913ff5c819c12146904465785bb74f9e73d916a2ec49c0828fc3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "434ff40adb5f855faa4bc2b9c47989152c9438d59950a084894af46cba888f5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0df352538f38dc01e9a1de35da3841149ea062deb58170bb9b962cd388842d23"
    sha256 cellar: :any_skip_relocation, ventura:        "e1e67cf32fae1a24d72bce024200af6ae59157bf7aa8abcc3a49c72286941669"
    sha256 cellar: :any_skip_relocation, monterey:       "9b2ad85ebd4d3d51e69f936262988bd8b10e10d0e56a34db612749fa514d88d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d43bf353d5a889b15227f3d6264e037543879f15479967ed42cb07877dbecdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca1e76b1a74e7faac0cb04b3798e8d4e7eec5f02ebb76cfd0f46c0bc8bac6844"
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
