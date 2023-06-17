class Gffread < Formula
  desc "GFF/GTF format conversions, region filtering, FASTA sequence extraction"
  homepage "https://github.com/gpertea/gffread"
  url "https://github.com/gpertea/gffread/releases/download/v0.12.7/gffread-0.12.7.tar.gz"
  sha256 "bfde1c857495e578f5b3af3c007a9aa40593e69450eafcc6a42c3e8ef08ed1f5"
  license "MIT"

  def install
    system "make", "release"
    bin.install "gffread"
  end

  test do
    resource "test_gtf" do
      url "https://raw.githubusercontent.com/gpertea/gffread/4959f6b/examples/output/annotation.gtf"
      sha256 "f8dcf147dd451e994cebfe054e120ecbf19fd40f99ae9e9865a312097c228741"
    end
    testpath.install resource("test_gtf")
    system bin/"gffread", "-E", testpath/"annotation.gtf", "-o", "ann_simple.gff"
    assert_match "##gff-version 3", (testpath/"ann_simple.gff").read

    assert_match version.to_s, shell_output("#{bin}/gffread --version")
  end
end
