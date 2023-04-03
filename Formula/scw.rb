class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v2.14.0.tar.gz"
  sha256 "d5335cc3638273fce42fad305683e8761e1648f59f93a6c110cc0c74c75d1c36"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "925bdbe657e0546261d8ca063ec2243e6c8e656f00a43d2314fc6317b4adaf6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "925bdbe657e0546261d8ca063ec2243e6c8e656f00a43d2314fc6317b4adaf6c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "925bdbe657e0546261d8ca063ec2243e6c8e656f00a43d2314fc6317b4adaf6c"
    sha256 cellar: :any_skip_relocation, ventura:        "a06fe7a3460dfa1cb2fb8487d5a8bb9ff268347ca0d5ce400a2be8ac823934bd"
    sha256 cellar: :any_skip_relocation, monterey:       "a06fe7a3460dfa1cb2fb8487d5a8bb9ff268347ca0d5ce400a2be8ac823934bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "a06fe7a3460dfa1cb2fb8487d5a8bb9ff268347ca0d5ce400a2be8ac823934bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afa78ffff7b4c1d42e6f0d1aa603b596fd44c1cabb3e635d10e328f6f68f365f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd/scw"

    generate_completions_from_executable(bin/"scw", "autocomplete", "script", shell_parameter_format: :none)
  end

  test do
    (testpath/"config.yaml").write ""
    output = shell_output(bin/"scw -c config.yaml config set access-key=SCWXXXXXXXXXXXXXXXXX")
    assert_match "✅ Successfully update config.", output
    assert_match "access_key: SCWXXXXXXXXXXXXXXXXX", File.read(testpath/"config.yaml")
  end
end
