class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v2.16.1.tar.gz"
  sha256 "f604c6e20a8ee651ba71d139f94c9d41989363ed7002cfb0f352e72f022d25a0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "afac9b6dc9b97ea770819876a79a24ce6c21072990c1481ae5b0d0295b298a42"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afac9b6dc9b97ea770819876a79a24ce6c21072990c1481ae5b0d0295b298a42"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "afac9b6dc9b97ea770819876a79a24ce6c21072990c1481ae5b0d0295b298a42"
    sha256 cellar: :any_skip_relocation, ventura:        "d4d3b1695efcec89e7f8b9f26a97693d128b543967fd786bb529a5401c17c1ce"
    sha256 cellar: :any_skip_relocation, monterey:       "d4d3b1695efcec89e7f8b9f26a97693d128b543967fd786bb529a5401c17c1ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4d3b1695efcec89e7f8b9f26a97693d128b543967fd786bb529a5401c17c1ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23c11e3d92935dbd78c52589cdfdaad97a6fe8026ab58a51b45e15396ed83e50"
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
