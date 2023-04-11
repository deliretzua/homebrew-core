class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.66.2.tar.gz"
  sha256 "dd8025c02673a1d70d9e288efa10a6d890fe9836681904c381bd0fdb87126843"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56f71ab222f6b8b167079e19e0fdb336ab61d87eff0993499d8c10a62b5e9f99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30b1575ea07914ba84f1960cbffe885d818c7119a09b1f020c6af7458bb50be4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4c8c030493a5df48d609878da0fef386087cbb2424bf2c9e19c2f54b29cef0d"
    sha256 cellar: :any_skip_relocation, ventura:        "1b3ea82f97c07b43d526426f43e0ebac4d68e62e1e3473917e0946dc30e94e04"
    sha256 cellar: :any_skip_relocation, monterey:       "bd9496a7431a5546180a2a797bc5df1e436c99c6635afa8b271f2ab096b7fe2b"
    sha256 cellar: :any_skip_relocation, big_sur:        "88badbd76025769b72db374e4ab22eace4fbd38ff82629fd4915f3ae752043c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92b86975807745e8b617f8c1fd6f7805e4d7e6451980cddf5f18ff6cd0869510"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell", base_name: "newrelic")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
