class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "578410a9dcda1797ff223601317afbc636ca546d6de4998c899e3e347b229be4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1f3ab581a6816c6e6daac635176dd23cb449f20040d55bfe554eca9834f19a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a1f3ab581a6816c6e6daac635176dd23cb449f20040d55bfe554eca9834f19a8"
    sha256 cellar: :any_skip_relocation, monterey:       "ad6ec94da92e05b2d086785811ac75e874e71d132ddc0a4c27ded682cdc8b753"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad6ec94da92e05b2d086785811ac75e874e71d132ddc0a4c27ded682cdc8b753"
    sha256 cellar: :any_skip_relocation, catalina:       "ad6ec94da92e05b2d086785811ac75e874e71d132ddc0a4c27ded682cdc8b753"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0074bba204d68f66be549e1c30b83409121e3a320517dfc27a82947cb727623"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/astronomer/astro-cli/version.CurrVersion=#{version}")
  end

  test do
    version_output = shell_output("#{bin}/astro version")
    assert_match("Astro CLI Version: #{version}", version_output)

    run_output = shell_output("echo 'y' | #{bin}/astro dev init")
    assert_match(/^Initializing Astro project*/, run_output)
    assert_predicate testpath/".astro/config.yaml", :exist?

    run_output = shell_output("echo 'test@invalid.io' | #{bin}/astro login astronomer.io", 1)
    assert_match(/^Welcome to the Astro CLI*/, run_output)
  end
end
