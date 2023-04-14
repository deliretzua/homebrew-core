class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptoslabs.com/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v1.0.10.tar.gz"
  sha256 "11d725b80cea33d92f1c35bb2e22357e7d4bea6312ecbd3ea0d7c33440ddb7ab"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "898d377870d982e66a9dbfc7b2dcd5f8cea29d0484d75fe3fa17c1b5954040f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7aac215d00db9e65b43c12e36894910993dca99b3e9014d3bda04a6caf779d13"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "408a7b7b7473042a9aa4ba9617bd225726030a40b8a5a08db519bb638abdde40"
    sha256 cellar: :any_skip_relocation, ventura:        "ed4c02996a60afa394536192c93b4ceb360d81aede4e1ac348a6cbf878f0479e"
    sha256 cellar: :any_skip_relocation, monterey:       "d1cab6d8a606d84ffe901eee61421d09380aef1fb1bc7d8cec86332a3b68405e"
    sha256 cellar: :any_skip_relocation, big_sur:        "a8df5de56939d9de77cbcd92df28f5e4f0556e986a5fd72345ba023a4fb29298"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff1d7f444c158b6bc20458260f69b11600a67b05644cd4c243cee57f6b8738ea"
  end

  depends_on "cmake" => :build
  depends_on "rustup-init" => :build
  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "zip" => :build
    depends_on "openssl@3"
    depends_on "systemd"
  end

  def install
    system "#{Formula["rustup-init"].bin}/rustup-init",
      "-qy", "--no-modify-path", "--default-toolchain", "1.64"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    system "./scripts/cli/build_cli_release.sh", "homebrew"
    bin.install "target/cli/aptos"
  end

  test do
    assert_match(/output.pub/i, shell_output("#{bin}/aptos key generate --output-file output"))
  end
end
