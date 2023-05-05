class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2023.5.5.tar.gz"
  sha256 "a293ad2c2fe09e61419ab1d68be4a2fb45a6ce669138f2630d1efeba6de19587"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "008048c59fde9fa4aa511c3c07987f72725e63f1e7fc84aea1cef43a333522bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "517e1205629e686d76049e8611a72be7de49a28ad3a7afa7ecff56498558fd0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "366f0fbd7a9024a4caea06e8d599146ddbbfa2409b67a12b0794b353538a3c2b"
    sha256 cellar: :any_skip_relocation, ventura:        "c94cf4e26e1dd1aed1db3815f93204e90943dbf5cb19fe171e903c38f580eb78"
    sha256 cellar: :any_skip_relocation, monterey:       "62f1428681e0b090012340e117b41d137481ad1b2e062e50ef4b3561af3515b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d74506c9b1a3dfb80862d30e9849d07c668ba3053eaa75197dff739effa38d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d313f7d66c990cfc9e3b95b2db91929fffc95bd38193dca275efeba4e404bae"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"observer_ward", "-u"
    assert_match "swagger", shell_output("#{bin}/observer_ward -t https://httpbin.org")
  end
end
