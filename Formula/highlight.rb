class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.php"
  url "http://www.andre-simon.de/zip/highlight-3.61.tar.bz2"
  sha256 "b3d0b1fafffd01d45a96e8ac0e981d18814e7482df3f9e0b499c6be9e0d1a970"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/saalen/highlight.git"

  bottle do
    sha256 arm64_big_sur: "e96e79486cab16ec84802064017f5e97d0f2e3e321e82b172299aff78dd4b82d"
    sha256 big_sur:       "83dffbd090b52dd14631f638d1efeb9af97787edee3845b81d366733580935ff"
    sha256 catalina:      "f7e4a91b1e26ff28387c0aa4f581a9d8a8973cca4608b04d02b44876cc734219"
    sha256 mojave:        "9add800d3b6e9fba4b5c1dc223b987a7c600eef0c75511b80102f939cca1a659"
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "lua"

  def install
    conf_dir = etc/"highlight/" # highlight needs a final / for conf_dir
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}"
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}", "install"
  end

  test do
    system bin/"highlight", doc/"extras/highlight_pipe.php"
  end
end
