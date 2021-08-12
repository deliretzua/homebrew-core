class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v7.0.2.tar.gz"
  sha256 "697b36bac910cd44399874499c9fc3cfd734d1a4938e1a777ac2acaa3f5269a7"
  license "Apache-2.0"
  head "https://github.com/gravitational/teleport.git"

  # We check the Git tags instead of using the `GithubLatest` strategy, as the
  # "latest" version can be incorrect. As of writing, two major versions of
  # `teleport` are being maintained side by side and the "latest" tag can point
  # to a release from the older major version.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "778532a9fb732fdca0084c15d3d23fcde832dca7ed61ee8ba53638b9963fe264"
    sha256 cellar: :any_skip_relocation, big_sur:       "46d0e70e476067e1919c8be3bca1b24bb642ba0aa73a5ee1b0b57a2d03793089"
    sha256 cellar: :any_skip_relocation, catalina:      "79462fc8df1309fe83fd284e242f2027a44daecb5efe90eada3ec9cfe8467987"
    sha256 cellar: :any_skip_relocation, mojave:        "5b6ae2bdc4ff1c9c06fa1426f1ec01847065a2158ab2f68da321df87ff93efbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98c6a1ead51e4bfddf30f1524e1053a82f5532875baae6dcffc12b8d43f43f22"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/2891baa0de7283f61c08ff2fa4494e53f9d4afc1.tar.gz"
    sha256 "7ce9278f35531f85d070e2e307c6e04d68ea4bbf757726a4776e284a68798776"
  end

  def install
    (buildpath/"webassets").install resource("webassets")
    ENV.deparallelize { system "make", "full" }
    bin.install Dir["build/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/teleport version")
    (testpath/"config.yml").write shell_output("#{bin}/teleport configure")
      .gsub("0.0.0.0", "127.0.0.1")
      .gsub("/var/lib/teleport", testpath)
      .gsub("/var/run", testpath)
      .gsub(/https_(.*)/, "")

    fork do
      exec "#{bin}/teleport start -c #{testpath}/config.yml --debug"
    end

    sleep 10
    system "curl", "--insecure", "https://localhost:3080"
    system "nc", "-z", "localhost", "3022"
    system "nc", "-z", "localhost", "3023"
    system "nc", "-z", "localhost", "3025"
  end
end
