class Reminiscence < Formula
  desc "Flashback engine reimplementation"
  homepage "http://cyxdown.free.fr/reminiscence/"
  url "http://cyxdown.free.fr/reminiscence/REminiscence-0.4.7.tar.bz2"
  sha256 "ef06d6230f9cae55177777713ccac5d2bb4913f075d0b964d593e41e22612874"

  livecheck do
    url :homepage
    regex(/href=.*?REminiscence[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "2bfceaf5574bb466177bea7a5cc2f6137212eba2d4cc4b6c547efcea3af5f52b"
    sha256 cellar: :any, big_sur:       "94e240b118e26f65e12fe087ba325a924841cdb57de69206f7433f4976b3ae55"
    sha256 cellar: :any, catalina:      "e5e9f65d1dcdfd16cea37f66f4d7f30a051fd5252bc330cb1e2c5740fb939d11"
    sha256 cellar: :any, mojave:        "1f9a8d59c676baae13f81ab411be784be4f7ae0cc55bee6ed2e14bab210473b7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libmodplug"
  depends_on "libogg"
  depends_on "sdl2"

  uses_from_macos "zlib"

  resource "tremor" do
    url "https://gitlab.xiph.org/xiph/tremor.git",
        revision: "7c30a66346199f3f09017a09567c6c8a3a0eedc8"
  end

  def install
    resource("tremor").stage do
      system "./autogen.sh", "--disable-dependency-tracking",
                             "--disable-silent-rules",
                             "--prefix=#{libexec}",
                             "--disable-static"
      system "make", "install"
    end

    ENV.prepend "CPPFLAGS", "-I#{libexec}/include"
    ENV.prepend "LDFLAGS", "-L#{libexec}/lib"

    system "make"
    bin.install "rs" => "reminiscence"
  end

  test do
    system bin/"reminiscence", "--help"
  end
end
