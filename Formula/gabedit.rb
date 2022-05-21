class Gabedit < Formula
  desc "GUI to computational chemistry packages like Gamess-US, Gaussian, etc."
  homepage "https://gabedit.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/gabedit/gabedit/Gabedit251/GabeditSrc251.tar.gz"
  version "2.5.1"
  sha256 "efcb00151af383f662d535a7a36a2b0ed2f14c420861a28807feaa9e938bff9e"

  # Consider switching back to checking SourceForge releases once we can alter
  # the matched version from `251` to `2.5.1`.
  livecheck do
    url "https://sites.google.com/site/allouchear/Home/gabedit/download"
    regex(/current stable version of gabedit is v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "0ee75766dad966a60b38b8a7f5abf71a134e808192c60bc41d55f847cafd4579"
    sha256 cellar: :any, big_sur:       "ec85ca37b2fce63ac9064364a740fef98389adb8729a6cdb1d2b969c8faff151"
    sha256 cellar: :any, catalina:      "af6b9870f2b34921313f3f38329a507e450462bf74055880f8c572e153c78932"
    sha256 cellar: :any, mojave:        "c8bd86798356203a2e554310149b51299c2221827a030fd74763c9237996fc9f"
    sha256 cellar: :any, high_sierra:   "83b205bd7a01eb782a9346f048c3c2e217ba4dc425f620853a4da066563e6b5c"
    sha256 cellar: :any, sierra:        "72d3d9bda815ffda49197241c46139686fbc0a4b2c9aeab2dce258573e5ea17b"
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"
  depends_on "gtkglext"

  on_linux do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    opengl_headers = if OS.mac?
      MacOS.sdk_path/"System/Library/Frameworks/OpenGL.framework/Headers"
    else
      Formula["mesa"].opt_include
    end

    (buildpath/"brew_include").install_symlink opengl_headers => "GL"

    inreplace "CONFIG" do |s|
      if OS.mac?
        s.gsub! "-lX11", ""
        s.gsub! "-lpangox-1.0", ""
      else
        # Add PKG_CONFIG_PATH to pangox-compat in gtkglext.
        ENV.append_path "PKG_CONFIG_PATH", Formula["gtkglext"].libexec/"lib/pkgconfig"
        s.gsub! "OGLLIB=-L/usr/lib -lGL -L/usr/lib -lGLU",
                "OGLLIB=-L#{Formula["mesa"].opt_lib} -lGL -L#{Formula["mesa-glu"].opt_lib} -lGLU"
      end
      s.gsub! "GTKCFLAGS =", "GTKCFLAGS = -I#{buildpath}/brew_include"
    end

    args = []
    if OS.mac?
      args << "OMPLIB=" << "OMPCFLAGS="
      ENV.append "LDFLAGS", "-undefined dynamic_lookup"
    end
    system "make", *args
    bin.install "gabedit"
  end

  test do
    assert_predicate bin/"gabedit", :exist?
  end
end
