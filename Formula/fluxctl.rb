class Fluxctl < Formula
  desc "Command-line tool to access Weave Flux, the Kubernetes GitOps operator"
  homepage "https://github.com/fluxcd/flux"
  url "https://github.com/fluxcd/flux.git",
      tag:      "1.21.2",
      revision: "9da931586cc857b2c9204b5f02725211661aa412"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "21279a68c5e174c9dc901b9de1782716cbc7130d85259ac24234e339a2573945"
    sha256 cellar: :any_skip_relocation, big_sur:       "53227e9833e63f339d03dc38c1b542debe9bc00cc122e40b128f37be43a7b03f"
    sha256 cellar: :any_skip_relocation, catalina:      "18d0f73be5406c24147a4092f05aed13788032a51c8acb7e3a62709889d2313c"
    sha256 cellar: :any_skip_relocation, mojave:        "26df944d2b25badcf9cb4a742b442f6e40657be2987b86ad0be7e7cf0296ebf0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.version=#{version}", "./cmd/fluxctl"
  end

  test do
    run_output = shell_output("#{bin}/fluxctl 2>&1")
    assert_match "fluxctl helps you deploy your code.", run_output

    version_output = shell_output("#{bin}/fluxctl version 2>&1")
    assert_match version.to_s, version_output

    # As we can't bring up a Kubernetes cluster in this test, we simply
    # run "fluxctl sync" and check that it 1) errors out, and 2) complains
    # about a missing .kube/config file.
    require "pty"
    require "timeout"
    r, _w, pid = PTY.spawn("#{bin}/fluxctl sync", err: :out)
    begin
      Timeout.timeout(5) do
        assert_match "Error: Could not load kubernetes configuration file", r.gets.chomp
        Process.wait pid
        assert_equal 1, $CHILD_STATUS.exitstatus
      end
    rescue Timeout::Error
      puts "process not finished in time, killing it"
      Process.kill("TERM", pid)
    end
  end
end
