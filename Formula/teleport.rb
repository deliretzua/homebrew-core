class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v8.0.6.tar.gz"
  sha256 "3373a2f1df364ab71f96e8b7a5bea6443d6903b3e54ee3fbf51e5e0f39e3bcec"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37f8775a51d6357e15d645292bfb82a744eec0c762dcc619d6c361a64f6274a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11e6f472e26689833997a60e67236255e3a5b0726d06fa7c15510cca5b9376d9"
    sha256 cellar: :any_skip_relocation, monterey:       "968ddbac9f48682edadd903d6597dc566b9d6b701fc54542c1f55c8022a29b35"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d8c2ae34f624bf4671d4591681ce22f58483a3ee2bb5ea1e95289c1dd5f78a0"
    sha256 cellar: :any_skip_relocation, catalina:       "6707542a72f84f7acc432bb82d9c8cb4c8eaf83a6a46f58de8c90ccaab5265af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e555f0d6ce99dd99e6d0dbe7a2d0e2497b2804edc16204b6efb35fad822f993"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/db4dbe5a7ec2d9bd1540f4fd89d0a6d1a52b8181.tar.gz"
    sha256 "a0a5b30644ade30adb6bf398d34335311326f4d83d42839fa7f47f2238de942f"
  end

  def install
    (buildpath/"webassets").install resource("webassets")
    ENV.deparallelize { system "make", "full" }
    bin.install Dir["build/*"]
  end

  test do
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
