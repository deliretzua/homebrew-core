class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.13.2.tar.gz"
  sha256 "765ce4014f6ab519c04276eca62fa76208ec6f9cd0cf2a75788832b1ec841f96"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5780a740ce6f7d40dfedf2d4408077cf9be298249af79fa5ba924ddc6f0d2c4b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5780a740ce6f7d40dfedf2d4408077cf9be298249af79fa5ba924ddc6f0d2c4b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5780a740ce6f7d40dfedf2d4408077cf9be298249af79fa5ba924ddc6f0d2c4b"
    sha256 cellar: :any_skip_relocation, ventura:        "1f2877ef935c86c36781ed19b0387afce79582de4ab1bfa4d4cdb5494330d99f"
    sha256 cellar: :any_skip_relocation, monterey:       "1f2877ef935c86c36781ed19b0387afce79582de4ab1bfa4d4cdb5494330d99f"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f2877ef935c86c36781ed19b0387afce79582de4ab1bfa4d4cdb5494330d99f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "160de4571bd081535d2fadbaa6491d48a50bb5483b713fc4fc6e6f8c26b040da"
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
