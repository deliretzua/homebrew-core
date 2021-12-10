class Blockhash < Formula
  desc "Perceptual image hash calculation tool"
  homepage "https://github.com/commonsmachinery/blockhash"
  url "https://github.com/commonsmachinery/blockhash/archive/v0.3.2.tar.gz"
  sha256 "add1e27e43b35dde56e44bc6d1f0556facf4a18a0f9072df04d4134d8f517365"
  license "MIT"
  head "https://github.com/commonsmachinery/blockhash.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "bb25e5ae4964868f4d3ce33bd622f5639d9dfcde90efdc444cfe1b6701ab283f"
    sha256 cellar: :any, arm64_big_sur:  "1263f1d1a652f85a0cd026b5f9d1e1df6f1f467aee9a4336dfcacd02d590253b"
    sha256 cellar: :any, monterey:       "16715363dffbf20fcd63777ee39f46998414fac808c841c5b4e82398ba1df18c"
    sha256 cellar: :any, big_sur:        "e7dad94beb23855c8bb9b9145da15b74b29f11f5125c3c9cb495d9894a747a3a"
    sha256 cellar: :any, catalina:       "16fa35be4bfea3e7e71ee26879f2e8508062b3f9684c178bc0204c0cec1e0284"
    sha256 cellar: :any, mojave:         "b6fd37575c7c00ab516240c916d7af8576655188c4fa830bf04833859d804b7f"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "imagemagick"

  resource "homebrew-testdata" do
    url "https://raw.githubusercontent.com/commonsmachinery/blockhash/ce08b465b658c4e886d49ec33361cee767f86db6/testdata/clipper_ship.jpg"
    sha256 "a9f6858876adadc83c8551b664632a9cf669c2aea4fec0c09d81171cc3b8a97f"
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.9"].opt_bin

    system "./waf", "configure", "--prefix=#{prefix}"
    # pkg-config adds -fopenmp flag during configuring
    # This fails the build on system clang, and OpenMP is not used in blockhash
    inreplace "build/c4che/_cache.py", "-fopenmp", ""
    system "./waf"
    system "./waf", "install"
  end

  test do
    resource("homebrew-testdata").stage testpath
    hash = "00007ff07ff07fe07fe67ff07560600077fe701e7f5e000079fd40410001ffff"
    result = shell_output("#{bin}/blockhash #{testpath}/clipper_ship.jpg")
    assert_match hash, result
  end
end
