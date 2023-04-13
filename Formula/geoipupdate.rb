class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/archive/v5.0.1.tar.gz"
  sha256 "b7443c65dc08b03e46e4e10e8ed2a03aaa95fbb143f1b50379d6cd7ad61b4b1e"
  license "Apache-2.0"
  head "https://github.com/maxmind/geoipupdate.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "8b411a54edf33d16456e3ac86db700f90d4313c79034b0be94fd0dba37e342de"
    sha256 arm64_monterey: "b304bfa0760a34cfc4344068da47eebef7d634a615e4b25c2f8be5c67301cb8b"
    sha256 arm64_big_sur:  "29e6d0b05fd7a8328d53ca3c916ba74ee7a9c8ef81f143550332482184237504"
    sha256 ventura:        "0d23c6e2fb59d1d8311beaba35d0d2f9914b2bc3613142024dd42b25a63d54f8"
    sha256 monterey:       "ee7202d159da1984d49b4babb0351255b7aee1188ae39ac74d29aab8764f26f6"
    sha256 big_sur:        "5266b7067e3d1c7409588fb3f7535f0e41de206d864a99a6ec367a343bae2b32"
    sha256 x86_64_linux:   "59aad00f2bb84111337a490072b52181ff2ad21435684e8b37ad147c11fde6f4"
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
