class Pgrok < Formula
  desc "Poor man's ngrok, multi-tenant HTTP/TCP reverse tunnel solution"
  homepage "https://github.com/pgrok/pgrok"
  url "https://github.com/pgrok/pgrok/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "15bac3b6c0a100e411eee39c044218869078c2f221b59c3a911d52040412ee72"
  license "MIT"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]

    ["pgrokd", "pgrok"].each do |f|
      system "go", "build", *std_go_args(ldflags: ldflags, output: bin/f), "./cmd/#{f}"
    end

    etc.install "pgrok.example.yml"
    etc.install "pgrokd.exmaple.yml"
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath

    output = shell_output("#{bin}/pgrokd --config #{etc}/pgrokd.exmaple.yml 2>&1", 1)
    assert_match "[error] failed to initialize database", output

    system bin/"pgrok", "init", "--remote-addr", "example.com:222",
                                "--forward-addr", "http://localhost:3000",
                                "--token", "brewtest"
    assert_match "brewtest", (testpath/"pgrok/pgrok.yml").read

    assert_match version.to_s, shell_output("#{bin}/pgrok --version")
  end
end
