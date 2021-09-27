class Ko < Formula
  desc "Build and deploy Go applications on Kubernetes"
  homepage "https://github.com/google/ko"
  url "https://github.com/google/ko/archive/v0.9.2.tar.gz"
  sha256 "d27ebf3c484dbc320810fff6024b1e759141512e9367a1f5a216dd787fb47f49"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c07b307a4a5a4a22501d099d331f222cf9b6d2ed1a21053c782872d21f1d936a"
    sha256 cellar: :any_skip_relocation, big_sur:       "2f8e6fcfc3205e830387bff26c4f5ac01ac9d4e9afbc902a7140976dd30cf965"
    sha256 cellar: :any_skip_relocation, catalina:      "bfd196ae4e4184bba5b4e5c6bad6b5dc4fab57af2f22b383d1ab00cb0090c030"
    sha256 cellar: :any_skip_relocation, mojave:        "359497988b2c425ff3ba43ab22e8b6dae276c51372f390e5fe065f448fe74768"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b93b10a18c9e5c04e4d3409e7f109d84680545b945ee53c614a98f6f8673c55b"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    system "go", "build", *std_go_args, "-ldflags",
      "-s -w -X github.com/google/ko/pkg/commands.Version=#{version}"
  end

  test do
    output = shell_output("#{bin}/ko login reg.example.com -u brew -p test 2>&1")
    assert_match "logged in via #{testpath}/.docker/config.json", output

    ENV["KO_DOCKER_REPO"] = "ko.local"
    output = shell_output("#{bin}/ko run github.com/mattmoor/examples/http/cmd/helloworld 2>&1", 1)
    assert_match "failed to publish images", output
  end
end
