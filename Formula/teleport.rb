class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v5.2.1.tar.gz"
  sha256 "4f03f1da266d0904a9e7c41a022ea4a2a03b7d2a7bd7bf3759e83ef23f8d86b3"
  license "Apache-2.0"
  head "https://github.com/gravitational/teleport.git"

  # We check the Git tags instead of using the `GithubLatest` strategy, as the
  # "latest" version can be incorrect. As of writing, two major versions of
  # `teleport` are being maintained side by side and the "latest" tag can point
  # to a release from the older major version.
  livecheck do
    url :stable
    strategy :git
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b13714e33f44d748f8110548cb09fb340150a28929b35e0ae798b1595dd54c1e"
    sha256 cellar: :any_skip_relocation, big_sur:       "9f9029a8e93694dfa7ef2bc0aadd20c4f6855ccf161e4a4170af9967953ff64d"
    sha256 cellar: :any_skip_relocation, catalina:      "7da55ca786ef8f141a656ef1252071dac4e6c0c571d8f3a03beb04d342d3eb6e"
    sha256 cellar: :any_skip_relocation, mojave:        "33e9823ce39c138305185dfbaae768ba629e5878ad37d620e6666b057bd38e1b"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/8ace0cfcc6867651bed3fd5b5f35aaa2a80e1106.tar.gz"
    sha256 "4af3c005d0ddc0215b621aa4bf13655dd7e7266cffced2cc7f64122e79c0949e"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOROOT"] = Formula["go"].opt_libexec

    (buildpath/"webassets").install resource("webassets")
    (buildpath/"src/github.com/gravitational/teleport").install buildpath.children
    cd "src/github.com/gravitational/teleport" do
      ENV.deparallelize { system "make", "full" }
      bin.install Dir["build/*"]
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/teleport version")
    (testpath/"config.yml").write shell_output("#{bin}/teleport configure")
      .gsub("0.0.0.0", "127.0.0.1")
      .gsub("/var/lib/teleport", testpath)
      .gsub("/var/run", testpath)
      .gsub(/https_(.*)/, "")
    begin
      pid = spawn("#{bin}/teleport start -c #{testpath}/config.yml")
      sleep 5
      system "/usr/bin/curl", "--insecure", "https://localhost:3080"
      system "/usr/bin/nc", "-z", "localhost", "3022"
      system "/usr/bin/nc", "-z", "localhost", "3023"
      system "/usr/bin/nc", "-z", "localhost", "3025"
    ensure
      Process.kill(9, pid)
    end
  end
end
