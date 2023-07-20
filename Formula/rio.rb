class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://raphamorim.io/rio/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.0.11.tar.gz"
  sha256 "06b581d72e3747563e6b1e4ea244d57a4b9d8cd916e786ccb047cf8faf897e03"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e136a5d375cc0037a35ad5fbf57f2087bb2f09f7dc3a599fc68844aaded61577"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e478e7dc9da84f56c6cdddd2c032fef2148b6cc871835aef3511190e3959e7fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0bb3aec6d48528a6fa132ce0d985c3942fb25efd44052b20a3e7d2c2c81f6615"
    sha256 cellar: :any_skip_relocation, ventura:        "1267372fd0c1ca6d96ff35d97715ffb6cb0f5402e4ad9719e5ea90308e6f08fa"
    sha256 cellar: :any_skip_relocation, monterey:       "ed90fdbb7e951af35898f113f4ae87802a345e8a56bc4175bfc970df52d45842"
    sha256 cellar: :any_skip_relocation, big_sur:        "dffc30ffb041fe0d649f38885c5e7b77a69b738629fd734117705fc725869531"
  end

  depends_on "rust" => :build
  # Rio does work for Linux although it requires a specification of which
  # window manager will be used (x11 or wayland) otherwise will not work.
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args(path: "rio")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rio --version")
    return if Hardware::CPU.intel? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    # This test does pass locally for x86 but it fails for containers
    # which is the case of x86 in the CI

    system bin/"rio", "-e", "touch", testpath/"testfile"
    assert_predicate testpath/"testfile", :exist?
  end
end
