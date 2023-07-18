class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.246.tar.gz"
  sha256 "b1c4a156afb8e51bceee0d95dc9a4988975b51ee05a11c887e869bd3985e33ee"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba1420f6100481e8f616ee8c75577b998e3e6e1a8c3cc34a1547336422874fdd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ebcdd88ecdc332d940bd57d92548cb88ff1917e07efe5b317761434b1bb13c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8138a8a44ba7a2d62f299c0aeb6a24414875c08bad87382abf0e9c675231d351"
    sha256 cellar: :any_skip_relocation, ventura:        "da9adff804d24f564e14665a213218d69d41574919c9bf7a3c7a8d43dad8fd07"
    sha256 cellar: :any_skip_relocation, monterey:       "7f47d07d50a3f8b042e2e1750849b9e4725558851ee5052615439a10eb08a25c"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d5e5dac407f48325521b5ae0ca185739497794eedc93cc18e102c2c675fe23a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d48b57a83f81d8b2eb3e4b87ac3c4ea1528186d2853b42f5a1cd7a07553062a"
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
