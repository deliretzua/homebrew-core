class Abyss < Formula
  desc "Genome sequence assembler for short reads"
  homepage "https://www.bcgsc.ca/resources/software/abyss"
  url "https://github.com/bcgsc/abyss/releases/download/2.3.7/abyss-2.3.7.tar.gz"
  sha256 "ba37780e79ec3aa359b6003e383caef13479a87f4d0022af01b86398f9ffca1f"
  license all_of: ["GPL-3.0-only", "LGPL-2.1-or-later", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4109a98fd3b68157787105d2d3da974641e5dc2fd6e63351c54e50a08305e199"
    sha256 cellar: :any,                 arm64_big_sur:  "e294340bf5c2c91945d555a21215031cbefcba168645c80fb97ad83f334ac07d"
    sha256 cellar: :any,                 monterey:       "ffca3c29f740aaa7ec67e51fc0f128d9feed8f016543b89cf1cb8c9f0aa60325"
    sha256 cellar: :any,                 big_sur:        "8ae5a988cf8c7a5a9834d2a3db1613ae152bf6990ee6eae14a17bbe559baf129"
    sha256 cellar: :any,                 catalina:       "7b591b8908cd7fa7dd97e26333457b20c0c60dcd32535cc07d39723014af3f90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79df263bc4e91030e73f64d0348bbb7753d3ad190d5e30a562cbcc414b17d495"
  end

  head do
    url "https://github.com/bcgsc/abyss.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "multimarkdown" => :build
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build # For btllib
  depends_on "google-sparsehash" => :build
  depends_on "meson" => :build # For btllib
  depends_on "ninja" => :build # For btllib
  depends_on "python@3.11" => :build # For btllib
  depends_on "gcc"
  depends_on "open-mpi"

  uses_from_macos "sqlite"

  fails_with gcc: "5"
  fails_with :clang # no OpenMP support

  resource "btllib" do
    url "https://github.com/bcgsc/btllib/releases/download/v1.6.0/btllib-1.6.0.tar.gz"
    sha256 "4a122c1047785dc865b8c94063714667f8ca43b8a881754eebd96dbb44fd1c3f"

    # Fixes 'uint' was not declared in this scope
    # Remove in next release
    patch do
      url "https://github.com/bcgsc/btllib/commit/43adf3d2671cc1ab780d23666e038055edb9d669.patch?full_index=1"
      sha256 "47e0f70501c8f5d543eb2a956a226f0a1a51816123a9b2061a081fb92c7b3f0c"
    end
  end

  resource "homebrew-testdata" do
    url "https://www.bcgsc.ca/sites/default/files/bioinformatics/software/abyss/releases/1.3.4/test-data.tar.gz"
    sha256 "28f8592203daf2d7c3b90887f9344ea54fda39451464a306ef0226224e5f4f0e"
  end

  def install
    ENV.delete("HOMEBREW_SDKROOT") if MacOS.version >= :mojave && MacOS::CLT.installed?

    (buildpath/"btllib").install resource("btllib")
    cd "btllib" do
      system "./compile"
    end

    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args,
                          "--enable-maxk=128",
                          "--with-boost=#{Formula["boost"].include}",
                          "--with-btllib=#{buildpath}/btllib/install",
                          "--with-mpi=#{Formula["open-mpi"].prefix}",
                          "--with-sparsehash=#{Formula["google-sparsehash"].prefix}",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    testpath.install resource("homebrew-testdata")
    if which("column")
      system "#{bin}/abyss-pe", "B=2G", "k=25", "name=ts", "in=reads1.fastq reads2.fastq"
    else
      # Fix error: abyss-tabtomd: column: not found
      system "#{bin}/abyss-pe", "B=2G", "unitigs", "scaffolds", "k=25", "name=ts", "in=reads1.fastq reads2.fastq"
    end
    system "#{bin}/abyss-fac", "ts-unitigs.fa"
  end
end
