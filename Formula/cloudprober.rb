class Cloudprober < Formula
  desc "Active monitoring software to detect failures before your customers do"
  homepage "https://cloudprober.org"
  url "https://github.com/cloudprober/cloudprober/archive/refs/tags/v0.12.8.tar.gz"
  sha256 "1b33653db6de2c2f07b2b4c552630b6ad9e21b49eeb0b07f73f1629d318bdd08"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a20bc475bc546c683d69b4686fc99a578890c18a38d9e168831c28485094a94b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5e522fa4fcaa11e2a745be31ac0f83a21d79dcba76d5919dd80113745f181a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dbb73bd0fefcf2c4a9eddd69b21d1f859f60ddc99d7894be82a8353a524a15ac"
    sha256 cellar: :any_skip_relocation, ventura:        "ebafe0a8dc1ea0174125420c60f0100fbc6e874c0897cc2df77747215225fa8b"
    sha256 cellar: :any_skip_relocation, monterey:       "5b334f4c33a6b57936a0538e6808049cf55d5a13bdd449f5c7e7f8a124a2eb3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "2edba1400c930a4e4009cb2dbc1f1742392ab8c54c419ff4e27e2c10da2217f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c065a6bb62fb1cdae2a0d9812dee65cf746c34060d67c8a36c78805168bc826"
  end

  depends_on "go" => :build

  def install
    system "make", "cloudprober", "VERSION=v#{version}"
    bin.install "cloudprober"
  end

  test do
    io = IO.popen("#{bin}/cloudprober --logtostderr", err: [:child, :out])
    io.any? do |line|
      line.include?("Initialized status surfacer")
    end
  end
end
