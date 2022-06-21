class MscGenerator < Formula
  desc "Draws signalling charts from textual description"
  homepage "https://gitlab.com/msc-generator/msc-generator"
  url "https://gitlab.com/api/v4/projects/31167732/packages/generic/msc-generator/7.3.1/msc-generator-7.3.1.tar.gz"
  sha256 "ee715cb0a9ca16d218d5092d6f9e4a2fa5366489beb03c9c65b03293d3c8e56a"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "5707ed7ae39ba1a9de555d6c11cf6f352725e196ab5fdf48e9b926e7dfa8bb17"
    sha256 arm64_big_sur:  "44aa53b6003d3a4a5dbbcaf26dd77850dddfc96beee584589fac8a8b8ec191a9"
    sha256 monterey:       "8db3175190bc5b0d33535a6397603aa191f60c1b54596279de10e063971df7b4"
    sha256 big_sur:        "a0e46ea25c940085fffcee6647459f5fb91c2fadc24e6f575554fff6da5ae7cf"
    sha256 catalina:       "d38e92aa74a198b8b64e39d5def5d8ce83a182c8acb90dabbb83cd240e8b753f"
    sha256 x86_64_linux:   "d5cf407d8bcbc6a65ac189613f0492df0f0c7592e57d9b0155cf4e39e0a7dc71"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "gcc"
  depends_on "glpk"
  depends_on "graphviz"
  depends_on "sdl2"

  fails_with :clang # needs std::range

  fails_with :gcc do
    version "9"
    cause "needs std::range"
  end

  def install
    system "./configure", *std_configure_args, "--disable-font-checks"
    system "make", "-C", "src", "install"
    system "make", "-C", "doc", "msc-gen.1"
    man1.install "doc/msc-gen.1"
  end

  test do
    # Try running the program
    system "#{bin}/msc-gen", "--version"
    # Construct a simple chart and check if PNG is generated (the default output format)
    (testpath/"simple.signalling").write("a->b;")
    system "#{bin}/msc-gen", "simple.signalling"
    assert_predicate testpath/"simple.png", :exist?
    bytes = File.binread(testpath/"simple.png")
    assert_equal bytes[0..7], "\x89PNG\r\n\x1a\n".force_encoding("ASCII-8BIT")
  end
end
