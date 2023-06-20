class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://raphamorim.io/rio/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.0.7.tar.gz"
  sha256 "5a3fcdc6bbad3274286bc41c5225c9ae576ffcd13b80649247656c0f41422de9"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

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
    system bin/"rio", "-e", "echo 1; exit"
  end
end
