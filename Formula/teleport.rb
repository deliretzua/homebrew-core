class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v10.1.2.tar.gz"
  sha256 "3d3ba65073f5524144e7145705e8e2ac46ff4ec3bc318f94c8849d30984ecc2d"
  license "Apache-2.0"
  head "https://github.com/gravitational/teleport.git", branch: "master"

  # We check the Git tags instead of using the `GithubLatest` strategy, as the
  # "latest" version can be incorrect. As of writing, two major versions of
  # `teleport` are being maintained side by side and the "latest" tag can point
  # to a release from the older major version.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0b0bbb2a6b7640154c64bc07e07374d0d8d341929493164f602912597e3b49d3"
    sha256 cellar: :any,                 arm64_big_sur:  "af09895d193977da1cf253067b25797e337c59439ed3b4ff4bb7fd1a8f5f2e16"
    sha256 cellar: :any,                 monterey:       "dc6df422436a9217996fd63439e932927f40f2bf22cf544c47d92672e1fbd624"
    sha256 cellar: :any,                 big_sur:        "ab4e1b37fdf4e2d0f439536e810eca956e2ae69440ae24fcf2d59b34ec69b264"
    sha256 cellar: :any,                 catalina:       "cb30e1306ffe699372cee958ec1b63012f9eef1957071f0b799dba271424e46f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fab4c68a015079538b8c71568c8d9c7b5e6ca019b92b39d8ece1b54fb548ddbd"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "libfido2"

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/7370f56cbd7e8c706503047ba5ff1fe874a3bdae.tar.gz"
    sha256 "7a84111fd076ec98f4e396dcea8d991467524457d2dbdd0865ee659dde7742a2"
  end

  def install
    (buildpath/"webassets").install resource("webassets")
    ENV.deparallelize { system "make", "full", "FIDO2=dynamic" }
    bin.install Dir["build/*"]
  end

  test do
    curl_output = shell_output("curl \"https://api.github.com/repos/gravitational/teleport/contents/webassets?ref=v#{version}\"")
    assert_match JSON.parse(curl_output)["sha"], resource("webassets").url
    assert_match version.to_s, shell_output("#{bin}/teleport version")
    assert_match version.to_s, shell_output("#{bin}/tsh version")
    assert_match version.to_s, shell_output("#{bin}/tctl version")

    mkdir testpath/"data"
    (testpath/"config.yml").write <<~EOS
      version: v2
      teleport:
        nodename: testhost
        data_dir: #{testpath}/data
        log:
          output: stderr
          severity: WARN
    EOS

    fork do
      exec "#{bin}/teleport start --roles=proxy,node,auth --config=#{testpath}/config.yml"
    end

    sleep 10
    system "curl", "--insecure", "https://localhost:3080"

    status = shell_output("#{bin}/tctl --config=#{testpath}/config.yml status")
    assert_match(/Cluster\s*testhost/, status)
    assert_match(/Version\s*#{version}/, status)
  end
end
