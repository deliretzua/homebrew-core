class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag.git",
      tag:      "v1.8.1",
      revision: "916857f01428cde7e3e3c07ee94f63f3e7a69c06"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "356ca7e6ff6d83a58fb7ed46e82af26fa60ade89f64e2febdc1ee472d8c1df11"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "356ca7e6ff6d83a58fb7ed46e82af26fa60ade89f64e2febdc1ee472d8c1df11"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "356ca7e6ff6d83a58fb7ed46e82af26fa60ade89f64e2febdc1ee472d8c1df11"
    sha256 cellar: :any_skip_relocation, ventura:        "29242e67ab6c16df73a6e05bac271d698a3b64f423bac972498617233fbb0030"
    sha256 cellar: :any_skip_relocation, monterey:       "c2b41b56cce970e47c8fa295824c47e647318a218398b47f3d84b3060d621c5c"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2b41b56cce970e47c8fa295824c47e647318a218398b47f3d84b3060d621c5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbcc1b2caeade31609ea3a729c7821c22625fb220ffa836ccfc79a969b315993"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/relayproxy"
  end

  test do
    port = free_port

    (testpath/"flags.yml").write <<~EOS
      test-flag:
        variations:
          true-var: true
          false-var: false
        defaultRule:
          variation: true-var
    EOS

    (testpath/"test.yml").write <<~EOS
      listen: #{port}
      pollingInterval: 1000
      retriever:
        kind: file
        path: #{testpath}/flags.yml
    EOS

    begin
      pid = fork do
        exec bin/"go-feature-flag-relay-proxy", "--config", "#{testpath}/test.yml"
      end
      sleep 3

      expected_output = /true/

      assert_match expected_output, shell_output("curl -s http://localhost:#{port}/health")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
