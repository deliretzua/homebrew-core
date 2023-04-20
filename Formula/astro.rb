class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "52616fa2e34214e21b839c41040a72c19b99c26b76f4539e04452c2ff9f9d37d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b66c4e5de8156a9c1af993f9fc2c822b464e35ea858496a93fd32c840f25f18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b66c4e5de8156a9c1af993f9fc2c822b464e35ea858496a93fd32c840f25f18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b66c4e5de8156a9c1af993f9fc2c822b464e35ea858496a93fd32c840f25f18"
    sha256 cellar: :any_skip_relocation, ventura:        "44eee0190553ab8ecc3a2defbe7d12e3b9e163ebe607567f91b1e8874ffb1a18"
    sha256 cellar: :any_skip_relocation, monterey:       "44eee0190553ab8ecc3a2defbe7d12e3b9e163ebe607567f91b1e8874ffb1a18"
    sha256 cellar: :any_skip_relocation, big_sur:        "44eee0190553ab8ecc3a2defbe7d12e3b9e163ebe607567f91b1e8874ffb1a18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f68dfeed929dd6e334aab138c5b7c9c8240855af9e21130802084245a818a49f"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/astronomer/astro-cli/version.CurrVersion=#{version}")

    generate_completions_from_executable(bin/"astro", "completion")
  end

  test do
    version_output = shell_output("#{bin}/astro version")
    assert_match("Astro CLI Version: #{version}", version_output)

    run_output = shell_output("echo 'y' | #{bin}/astro dev init")
    assert_match(/^Initializing Astro project*/, run_output)
    assert_predicate testpath/".astro/config.yaml", :exist?

    run_output = shell_output("echo 'test@invalid.io' | #{bin}/astro login astronomer.io --token-login=test", 1)
    assert_match(/^Welcome to the Astro CLI*/, run_output)
  end
end
