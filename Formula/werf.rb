class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.237.tar.gz"
  sha256 "4138ef858829c91cfa7aa2d9f4cc760e123e17166f7c77846ebecb1b8d6af032"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a999055f1cd6b5f01ab658b36ebfd19d9462e787bd52d30b377ba1f27c7394bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "097ad837797affaa6575463f2acc9729dbf684d73fd3843b9cca56333f5d61dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8754533f1dac3181843a1374a156be67ca7203bd4c2c13ff366b6bd797dfae7a"
    sha256 cellar: :any_skip_relocation, ventura:        "ae1ec552dde0d9128d7b1cf8bc8cade99f446d387e8c7338edbe4096e36a9320"
    sha256 cellar: :any_skip_relocation, monterey:       "004dbd9f051883db1987e6d4ee8174054ea16a34a0d2048661e4f1772e8a3777"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0351e10ea08ddc8d4ee367505c52c60e9693ba4e126ad51f514ccb95304bc65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2a07eac199d29c06d137c7d912a1dbfb834c4fa511e4afabdba74d86532bbc8"
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
