class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://github.com/tensorchord/envd/archive/v0.3.18.tar.gz"
  sha256 "cad28aa40ee43cab39df296cc5d603776a09f866b54d2c9b03cac4a0197d114b"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8ae526cfaeee1c7d4ce290ddf73800ab280beaf30dd3df0d1fb948baced3e02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c3648c99a881b7f25707fcb438322cf6d75a23e069121eb646d591b51b16e14"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d9ddb1051ef6ba1b89ce3b946b630af8b775a2f6b0d16c8f0b569a783613629"
    sha256 cellar: :any_skip_relocation, ventura:        "90edd8a6c90eac8ac4d636f6a1e11a85d3adbee9e8847d1cb92a7ac5424c5acb"
    sha256 cellar: :any_skip_relocation, monterey:       "2d8693205c60ae3659bd0696b5c34fee012b18adfab5b44ebf228e68688dc50c"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce04eb4c1f0591d806410e9b5d26cd657a2b137af9bd3a477a35657ef0709640"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d07b049651412554fe47c40f86ee0deca26416721965253c316dc30bf5f0625a"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/tensorchord/envd/pkg/version.buildDate=#{time.iso8601}
      -X github.com/tensorchord/envd/pkg/version.version=#{version}
      -X github.com/tensorchord/envd/pkg/version.gitTag=v#{version}
      -X github.com/tensorchord/envd/pkg/version.gitCommit=#{version}-#{tap.user}
      -X github.com/tensorchord/envd/pkg/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/envd"
    generate_completions_from_executable(bin/"envd", "completion", "--no-install",
                                         shell_parameter_format: "--shell=",
                                         shells:                 [:bash, :zsh])
  end

  test do
    output = shell_output("#{bin}/envd version --short")
    assert_equal "envd: v#{version}", output.strip

    expected = if OS.mac?
      "error: Cannot connect to the Docker daemon"
    else
      "error: permission denied"
    end

    stderr = shell_output("#{bin}/envd env list 2>&1", 1)
    assert_match expected, stderr
  end
end
