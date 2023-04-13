class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/archive/v5.0.1.tar.gz"
  sha256 "b7443c65dc08b03e46e4e10e8ed2a03aaa95fbb143f1b50379d6cd7ad61b4b1e"
  license "Apache-2.0"
  head "https://github.com/maxmind/geoipupdate.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "1030e0ad67bc384a9638b20aaca048658d8603b15907d746a5c3367bb0dc930f"
    sha256 arm64_monterey: "5743b34f6da925db77db8ae3a3ed802be016673eeca3429d4d98caccd85b7d40"
    sha256 arm64_big_sur:  "aece95797431f1c61a21024c7c97c2f179554ada85ee9ae98c98062af0b054fd"
    sha256 ventura:        "9efc2031400a0a4a74f9604ad95a91fe531b4d91c40de171a605e319fb369cb8"
    sha256 monterey:       "8554461f3f1bef6bbc80c4816cee1b3e6632c0d62de11ae83fa63d495b30d5f8"
    sha256 big_sur:        "d54619076d0a9362281967db2716afb86d6e3b3500e636c277b3de83c28a756e"
    sha256 x86_64_linux:   "e35e4c1b48bc8afbf39850b137c33fd08a4ff979c637d6e0f9e7c2abc53be679"
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    system "make", "CONFFILE=#{etc}/GeoIP.conf", "DATADIR=#{var}/GeoIP", "VERSION=#{version} (homebrew)"

    bin.install  "build/geoipupdate"
    etc.install  "build/GeoIP.conf"
    man1.install "build/geoipupdate.1"
    man5.install "build/GeoIP.conf.5"
  end

  def post_install
    (var/"GeoIP").mkpath
  end

  test do
    system "#{bin}/geoipupdate", "-V"
  end
end
