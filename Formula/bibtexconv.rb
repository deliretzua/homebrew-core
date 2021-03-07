class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://www.uni-due.de/~be0001/bibtexconv/"
  url "https://github.com/dreibh/bibtexconv/archive/bibtexconv-1.1.22.tar.gz"
  sha256 "dfa7d12223100d04d4bdb2a26c8dec2efacf872140f5301ab111af8497b7163f"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/bibtexconv.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "2c90a1c81f350093a862088c37e3a492277a09cfc714af431f0f1564306e88cb"
    sha256 cellar: :any, big_sur:       "3325b26408a05b02c8a9002993168aa97fec5c7749556c47dcd0494aed99ad8a"
    sha256 cellar: :any, catalina:      "825df161159801283a8a9a500e2854417c3d4d461c8012e782e0bea6f9accced"
    sha256 cellar: :any, mojave:        "21f9bb60c2858343772d50f1cb6fa5075800a6804491643a9db6dd02d3224785"
    sha256 cellar: :any, high_sierra:   "9820d6c2634a28a2c8fd510a71d5929cf1f83c7e5bcaffc41056536a3c3df9a9"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "curl"

  def install
    system "cmake", *std_cmake_args,
                    "-DCRYPTO_LIBRARY=#{Formula["openssl@1.1"].opt_lib}/#{shared_library("libcrypto")}"
    system "make", "install"
  end

  test do
    cp "#{opt_share}/doc/bibtexconv/examples/ExampleReferences.bib", testpath

    system bin/"bibtexconv", "#{testpath}/ExampleReferences.bib",
                             "-export-to-bibtex=UpdatedReferences.bib",
                             "-check-urls", "-only-check-new-urls",
                             "-non-interactive"
  end
end
