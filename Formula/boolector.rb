class Boolector < Formula
  desc "SMT solver for fixed-size bit-vectors"
  homepage "https://boolector.github.io/"
  url "https://github.com/Boolector/boolector/archive/refs/tags/3.2.2.tar.gz"
  sha256 "9a5bdbacf83f2dd81dbed1e1a9f923766807470afa29b73729c947ae769d42b9"
  license "MIT"

  depends_on "cmake" => :build

  # Use commit hash from `contrib/setup-lingeling.sh`
  resource "lingeling" do
    url "https://github.com/arminbiere/lingeling/archive/7d5db72420b95ab356c98ca7f7a4681ed2c59c70.tar.gz"
    sha256 "cf04c8f5706c14f00dd66e4db529c48513a450cc0f195242d8d0762b415f4427"
  end

  # Use commit has from `contrib/setup-btor2tools.sh`
  resource "btor2tools" do
    url "https://github.com/boolector/btor2tools/archive/1df768d75adfb13a8f922f5ffdd1d58e80cb1cc2.tar.gz"
    sha256 "cee19843635a15ad599424a5ad098669938afed85f6d3341e5d661cf7cd5b261"
  end

  def install
    deps_dir = buildpath/"deps/install"

    resource("lingeling").stage do
      system "./configure.sh", "-fPIC"
      system "make"
      (deps_dir/"lib").install "liblgl.a"
      (deps_dir/"include").install "lglib.h"
    end

    resource("btor2tools").stage do
      system "./configure.sh", "-fPIC"
      system "make"
      (deps_dir/"lib").install "build/libbtor2parser.a"
      (deps_dir/"include/btor2parser").install "src/btor2parser/btor2parser.h"
    end

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.btor").write <<~EOS
      (set-logic BV)
      (declare-fun x () (_ BitVec 4))
      (declare-fun y () (_ BitVec 4))
      (assert (= (bvadd x y) (_ bv6 4)))
      (check-sat)
      (get-value (x y))
    EOS
    assert_match "sat", shell_output("#{bin}/boolector test.btor 2>/dev/null", 1)
  end
end
