class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.155.0",
      revision: "8089f4491c0a13ff99e538a6ad8636e1481d53dd"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9234a3697a2e2e8721d3f3d53ece00a1d933840b73b63b6cbfa4a613aad632eb"
    sha256 cellar: :any,                 arm64_big_sur:  "84ffc2a40a2e5d39407a05cd73180e1d43843151ccdae93d082f4fc1215d2d64"
    sha256 cellar: :any,                 monterey:       "f063faf7baab2ba8bb2d30d924c85be34dabbe6d6e4e70a9eaf1235df77aef32"
    sha256 cellar: :any,                 big_sur:        "f9aa314312529aa103f320c42b6ca1aead335320d483655030b9978702a6d781"
    sha256 cellar: :any,                 catalina:       "5ed910a418b84e8f37c84e2c127134d1d5d66d4332e87b4efab3b4563035a9c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "319cd9d7b5bca115306ed0d0255c40e24dc773508b3f80f6721dea30991b6661"
  end

  depends_on "go" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  # NOTE: The version here is specified in the go.mod of influxdb.
  # If you're upgrading to a newer influxdb version, check to see if this needs upgraded too.
  resource "pkg-config-wrapper" do
    url "https://github.com/influxdata/pkg-config/archive/v0.2.11.tar.gz"
    sha256 "52b22c151163dfb051fd44e7d103fc4cde6ae8ff852ffc13adeef19d21c36682"
  end

  def install
    # Set up the influxdata pkg-config wrapper to enable just-in-time compilation & linking
    # of the Rust components in the server.
    resource("pkg-config-wrapper").stage do
      system "go", "build", *std_go_args(output: buildpath/"bootstrap/pkg-config")
    end
    ENV.prepend_path "PATH", buildpath/"bootstrap"

    system "make", "build"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/flux"
    include.install "libflux/include/influxdata"
    lib.install Dir["libflux/target/*/release/libflux.{dylib,a,so}"]
  end

  test do
    assert_equal "8\n", shell_output(bin/"flux execute \"5.0 + 3.0\"")
  end
end
