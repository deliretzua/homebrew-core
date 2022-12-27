class Vlang < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  # NOTE: Keep this in sync with V compiler below when updating
  url "https://github.com/vlang/v/archive/refs/tags/0.3.2.tar.gz"
  sha256 "a1eece20503bee18a8a5f9f2a5cedd1ba7b3f5c2ee181886cc67ba703a43eb7c"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c081325dfa17516e4d8bc5cfca8c610208c15e5d84938ca5a3a75c72a0bbca80"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd921f6a5fececa1d04ad1361ba19c1da4ae361b88d3862fa02f7747bb87b0cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9fc0d5fea246584518fc01c59483f07ad89274c78606a70cb4623be28380f7d0"
    sha256 cellar: :any_skip_relocation, ventura:        "664f602968c98de14dfa5f92f106c2016dc8a0517c2928336ad38e3404502940"
    sha256 cellar: :any_skip_relocation, monterey:       "4fcb57b3de12ecd576bc4495d7446872ae68218200ec3e32c7889f59f1e8e2c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "19266863aa98b5a45d9b423db1924fd03470453ed9e5b8ca958fc4abecf6f88c"
    sha256 cellar: :any_skip_relocation, catalina:       "60e0f440e473d751fdc8ad1704105f8c1ac870a742740d7f7335e39c47a8929f"
    sha256 cellar: :any_skip_relocation, mojave:         "03d594231e0e381fe454dfde377062e9b1d77f1845e3863896027fc856455829"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a9db9337867f25273de9744c53e8956245e6c17531fde5cc57bf39520ef4763"
  end

  depends_on "bdw-gc"

  resource "vc" do
    # For every vlang release there is a matching commit of the V compiler in the format
    # "[v:master] {short SHA of the vlang release commit} - {vlang version number}".
    # The sources of this V compiler commit need to be used here
    url "https://github.com/vlang/vc.git",
        revision: "f96a25aee506a6025d716c8520c0a492374081c6"
  end

  # upstream discussion, https://github.com/vlang/v/issues/16776
  # macport patch commit, https://github.com/macports/macports-ports/commit/b3e0742a
  patch :DATA

  def install
    inreplace "vlib/builtin/builtin_d_gcboehm.c.v", "@PREFIX@", Formula["bdw-gc"].opt_prefix

    resource("vc").stage do
      system ENV.cc, "-std=gnu11", "-w", "-o", buildpath/"v1", "v.c", "-lm"
    end
    system "./v1", "-no-parallel", "-o", buildpath/"v2", "cmd/v"
    system "./v2", "-o", buildpath/"v", "cmd/v"
    rm ["./v1", "./v2"]
    libexec.install "cmd", "thirdparty", "v", "v.mod", "vlib"
    bin.install_symlink libexec/"v"
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/hello_world.v", testpath
    system bin/"v", "-o", "test", "hello_world.v"
    assert_equal "Hello, World!", shell_output("./test").chomp
  end
end

__END__
diff --git a/vlib/builtin/builtin_d_gcboehm.c.v b/vlib/builtin/builtin_d_gcboehm.c.v
index 0a13b64..23fca2b 100644
--- a/vlib/builtin/builtin_d_gcboehm.c.v
+++ b/vlib/builtin/builtin_d_gcboehm.c.v
@@ -31,12 +31,12 @@ $if dynamic_boehm ? {
 } $else {
 	$if macos || linux {
 		#flag -DGC_BUILTIN_ATOMIC=1
-		#flag -I @VEXEROOT/thirdparty/libgc/include
-		$if (prod && !tinyc && !debug) || !(amd64 || arm64 || i386 || arm32) {
+		#flag -I @PREFIX@/include
+		$if (!macos && prod && !tinyc && !debug) || !(amd64 || arm64 || i386 || arm32) {
 			// TODO: replace the architecture check with a `!$exists("@VEXEROOT/thirdparty/tcc/lib/libgc.a")` comptime call
 			#flag @VEXEROOT/thirdparty/libgc/gc.o
 		} $else {
-			#flag @VEXEROOT/thirdparty/tcc/lib/libgc.a
+			#flag @PREFIX@/lib/libgc.a
 		}
 		$if macos {
 			#flag -DMPROTECT_VDB=1
