class Tlsx < Formula
  desc "Fast and configurable TLS grabber focused on TLS based data collection"
  homepage "https://github.com/projectdiscovery/tlsx"
  url "https://github.com/projectdiscovery/tlsx/archive/v1.0.9.tar.gz"
  sha256 "036fb003412b05407c84424311c59fb4c41a63b63ad5300f226e5fa4fd7b439c"
  license "MIT"
  head "https://github.com/projectdiscovery/tlsx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a03fc9de141858ae81a9fa2c63fc41ebd5de1e262b64a869d7b4c487f9a7265"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a03fc9de141858ae81a9fa2c63fc41ebd5de1e262b64a869d7b4c487f9a7265"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a03fc9de141858ae81a9fa2c63fc41ebd5de1e262b64a869d7b4c487f9a7265"
    sha256 cellar: :any_skip_relocation, ventura:        "b07bf28d2d9d5d148d02c1b54901fe75738d8c9a606f1c32b628322049720817"
    sha256 cellar: :any_skip_relocation, monterey:       "e9fff48d84ee64473c6833d8c855567acb65b13163fb4ed2e5820165c4a8d843"
    sha256 cellar: :any_skip_relocation, big_sur:        "e726a2bbc9eee0702e59c89526eceab00c611e4642fff63165583fa8392a49c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90402d3ba392069d5d61295aff8c68c76f78f19386bb6f54842cc579a6f0aaab"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/tlsx/main.go"
  end

  test do
    system bin/"tlsx", "-u", "expired.badssl.com:443", "-expired"
  end
end
