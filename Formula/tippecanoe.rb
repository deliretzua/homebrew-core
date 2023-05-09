class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://github.com/felt/tippecanoe/archive/refs/tags/2.26.0.tar.gz"
  sha256 "6f38a94f166d5cc975b675055ebe15b7368ac52d91eb00a9a643eef700d0b8bc"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e65407a26dac4eac03f7a96c07e40648706071dab4e9a90f230dcdf6f201440"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19b445de34ba20b56225ebe47eb76417f3b162f44a3bebd99f6609a3e2097b4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59c154ab5089002c0f5e8a7951968a5832db4cc8a6dbcea606ae4aa6c6b30d9e"
    sha256 cellar: :any_skip_relocation, ventura:        "3ecfc604a30640e3bb4c7a8ac06f28fc1d1fa0c19d45f0ae86d510ed0a50d139"
    sha256 cellar: :any_skip_relocation, monterey:       "5829f726014cc3baa4c4d38ce0bc6a856cff4362080fad2453a305fa0597ad73"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b16780d5e8221459ee01eefd0a7a0c567fe716da87faf3a94d337fb83d53900"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd61da9501b5967afeb536cec67a0de4613a2b9e30dae781df70811fe165d3eb"
  end

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.json").write <<~EOS
      {"type":"Feature","properties":{},"geometry":{"type":"Point","coordinates":[0,0]}}
    EOS
    safe_system "#{bin}/tippecanoe", "-o", "test.mbtiles", "test.json"
    assert_predicate testpath/"test.mbtiles", :exist?, "tippecanoe generated no output!"
  end
end
