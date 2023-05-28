class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://github.com/openfga/openfga/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "2534b5c9b85c5abf177211b6070f5d2691817196ee6d1c31d4f9ca038602a34c"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/openfga/openfga/internal/build.Version=#{version}
      -X github.com/openfga/openfga/internal/build.Commit=brew
      -X github.com/openfga/openfga/internal/build.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/openfga"

    generate_completions_from_executable(bin/"openfga", "completion")
  end

  test do
    port = free_port
    pid = fork do
      exec bin/"openfga", "run", "--playground-port", port.to_s
    end
    sleep 3
    output = shell_output("curl -s http://localhost:#{port}/playground")
    assert_match "title=\"Embedded Playground\"", output

    assert_match version.to_s, shell_output(bin/"openfga version 2>&1")
  ensure
    Process.kill("SIGTERM", pid)
    Process.wait(pid)
  end
end
