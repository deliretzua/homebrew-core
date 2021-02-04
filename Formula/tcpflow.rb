class Tcpflow < Formula
  desc "TCP/IP packet demultiplexer"
  homepage "https://github.com/simsong/tcpflow"
  url "https://github.com/simsong/tcpflow/releases/download/tcpflow-1.5.0/tcpflow-1.5.0.tar.gz"
  sha256 "20abe3353a49a13dcde17ad318d839df6312aa6e958203ea710b37bede33d988"
  license "GPL-3.0"
  revision 1

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:tcpflow[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "478038c100cf6ffc2ef287bab32f37fa3413da393e4a1293a22ab3b9dd1a8251"
    sha256 cellar: :any, big_sur:       "adc2978737bdd9f205a3108818521906bf6d5bd8a57d8a4a6dd1e7855bf6eb06"
    sha256 cellar: :any, catalina:      "ee9e12b090ff836bf8bd39024f7c8d075e03357bb7c4eca504838e118d06fd6d"
    sha256 cellar: :any, mojave:        "ae7eb58e5d805e61b4fc79165574796bf59d2172977579b8716c2ea95631aa42"
    sha256 cellar: :any, high_sierra:   "3b29b20c24395a16a17236a89a5b4ff1121ae2227af79717517b02825a4a7dd7"
    sha256 cellar: :any, sierra:        "881535a6ab635522f3a64aa9b568ee9fc67476f4636236f17d2828c02518b8bf"
  end

  head do
    url "https://github.com/simsong/tcpflow.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "boost" => :build
  depends_on "openssl@1.1"

  def install
    system "bash", "./bootstrap.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
