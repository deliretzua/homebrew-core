class Monolith < Formula
  desc "CLI tool for saving complete web pages as a single HTML file"
  homepage "https://github.com/Y2Z/monolith"
  url "https://github.com/Y2Z/monolith/archive/v2.4.1.tar.gz"
  sha256 "d68980bd5ade841f41e0d35447f9c299c82118eef2d291c2c07063086a18de0d"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "478279d751123e01c26ca6426c5b81b1a905f6160cc8743fb61caa5718c1d991"
    sha256 cellar: :any_skip_relocation, big_sur:       "0fe966e60aba778a8fb0db2a0d62b95fce87b8ba3484aa8a8f3ef376c0ff5f22"
    sha256 cellar: :any_skip_relocation, catalina:      "f0f53627bafa8b487dd31ae9a7fb33c69f5ec87b2129e9f26a7f8beacd3f8a97"
    sha256 cellar: :any_skip_relocation, mojave:        "7c8df579c475560e352f38e538967067e03d30a11658b2c18a158de25cfc1458"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"monolith", "https://lyrics.github.io/db/P/Portishead/Dummy/Roads/"
  end
end
