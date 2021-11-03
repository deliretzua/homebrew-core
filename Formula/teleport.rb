class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v7.3.3.tar.gz"
  sha256 "893fb8e06f28eb5ee48989bf8e4fa2358a41d65d3c0372fe95076c948b530514"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5e1f78ee98f0af84c8941414b1a76f672d08aacdb852fb91afec9b9733e671b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4644f5022540da4bce40feb1fcd9f1420b2f1445d882f1d603e7d456d6fe9570"
    sha256 cellar: :any_skip_relocation, monterey:       "e5de354d61df7d99b5a9cd9582079629ab7896105bcf01febf9270e42ba3927d"
    sha256 cellar: :any_skip_relocation, big_sur:        "56d5af88d11f8a0f1bf45eda3464d37b53484d7f442114ed99643fb2dd316191"
    sha256 cellar: :any_skip_relocation, catalina:       "da16b0dde298168d31e61b6e1b28de52fe85751563e7ad1666bb8feb1dcfea3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f02ece77deb63d4729016ec7d51f0a02dddeab783eb3a9ac89315620112ab12a"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/07493a5e78677de448b0e35bd72bf1dc6498b5ea.tar.gz"
    sha256 "2074ee7e50720f20ff1b4da923434c05f6e1664e13694adde9522bf9ab09e0fd"
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
