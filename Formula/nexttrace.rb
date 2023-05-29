class Nexttrace < Formula
  desc "Open source visual route tracking CLI tool"
  homepage "https://github.com/sjlleo/nexttrace"
  url "https://github.com/sjlleo/nexttrace/archive/refs/tags/v1.1.6.tar.gz"
  sha256 "0198c331ec6fa3f4042389ef80faa05a5f33a37708c46d2a23b567bb97c5c80f"
  license "GPL-3.0-only"
  head "https://github.com/sjlleo/nexttrace.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/xgadget-lab/nexttrace/printer.version=#{version}
      -X github.com/xgadget-lab/nexttrace/printer.commitID=brew
      -X github.com/xgadget-lab/nexttrace/printer.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  def caveats
    <<~EOS
      nexttrace requires root privileges so you will need to run `sudo nexttrace <ip>`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    # requires `sudo` to start
    output = shell_output(bin/"nexttrace --language en 1.1.1.1 2>&1", 1)
    assert_match "traceroute to 1.1.1.1", output

    assert_match version.to_s, shell_output(bin/"nexttrace --version")
  end
end
