class Sparse < Formula
  desc "Static C code analysis tool"
  homepage "https://sparse.wiki.kernel.org/"
  url "https://www.kernel.org/pub/software/devel/sparse/dist/sparse-0.6.4.tar.xz"
  sha256 "6ab28b4991bc6aedbd73550291360aa6ab3df41f59206a9bde9690208a6e387c"
  head "https://git.kernel.org/pub/scm/devel/sparse/sparse.git", branch: "master"

  bottle do
    sha256                               arm64_big_sur: "7ba6578a0d29486b5839541706bcf448dd2babb0a1132c2956e2ce92ba3f0657"
    sha256                               big_sur:       "da170eea78ffe877b82b853f04ed4bd7487029c288c482f13cf798b70a1560c0"
    sha256                               catalina:      "1fb15ba5444a7c67d9f45215fc02e948583c28d8078546b3e0f766df50a1a859"
    sha256                               mojave:        "ac0ade8d4c0f98cadcca728fdd3c0694e3d3a4432c57edf0725542a91d750128"
    sha256                               high_sierra:   "7dcabb27270d98a6ad13d6b2c6b8c1bf3f0a9fa001a9737db841f1cd604dbeec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb32b4bafbf60ea280ea724a623376d9c74e36cd546f39d59318a23ab4ede874"
  end

  depends_on "gcc" if DevelopmentTools.clang_build_version < 1100

  # error: use of unknown builtin '__builtin_clrsb'
  fails_with :clang if DevelopmentTools.clang_build_version < 1100

  def install
    # BSD "install" does not understand the GNU -D flag.
    # Create the parent directories ourselves.
    inreplace "Makefile", "install -D", "install"
    bin.mkpath
    man1.mkpath

    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.C").write("int main(int a) {return a;}\n")
    system "#{bin}/sparse", testpath/"test.C"
  end
end
