class Kallisto < Formula
  desc "Quantify abundances of transcripts from RNA-Seq data"
  homepage "https://pachterlab.github.io/kallisto/"
  url "https://github.com/pachterlab/kallisto/archive/v0.50.0.tar.gz"
  sha256 "f9cc0058d08206cb6dde4a4dcaf8a778df5a939a6e021508eea9b00b0d6d5368"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a77f40e079be6c8a6e762ae3c72cee556704605ef948b0a5b84278267a091fc2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "744b380617797b2d8e7de96fde867fde93d4a99e3be50e0ee55b4bfd63a6ead1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "189fba3400b85552f7caa05058b92a8efe8115e89a488f92e5466982f6a03ca4"
    sha256 cellar: :any_skip_relocation, ventura:        "8ba268ecbe91927be13f4b882a204132d77747ca2e9dc381cd84cb6b6b516342"
    sha256 cellar: :any_skip_relocation, monterey:       "a3e87554317235569004690fb34c87590800f5e6159042dc587b454a39e43db9"
    sha256 cellar: :any_skip_relocation, big_sur:        "ffc3507403994dfd317a6f63118879427239ee9a94c37bb4823f8a48ec9f8da2"
    sha256 cellar: :any_skip_relocation, catalina:       "267cdea1b28358181c8701dd4bf0d2ed297df3be0298c80499199f89aa6bd6de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20207d99e10ff85645eb4b3ceec5359e74af6772bc51496a48c00807d4a9eabe"
  end

  depends_on "cmake" => :build
  depends_on "hdf5"

  def install
    ENV.deparallelize

    system "cmake", ".", "-DUSE_HDF5=ON", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >seq0
      FQTWEEFSRAAEKLYLADPMKVRVVLKYRHVDGNLCIKVTDDLVCLVYRTDQAQDVKKIEKF
    EOS
    output = shell_output("#{bin}/kallisto index -i test.index test.fasta 2>&1")
    assert_match "has 1 contigs and contains 32 k-mers", output
  end
end
