class Icu4c < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "http://site.icu-project.org/home"
  url "https://github.com/unicode-org/icu/releases/download/release-68-2/icu4c-68_2-src.tgz"
  version "68.2"
  sha256 "c79193dee3907a2199b8296a93b52c5cb74332c26f3d167269487680d479d625"
  license "ICU"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:[.-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.gsub("-", ".") }.compact
    end
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "28603c8d1cc113f70ad4042548f8f6585606025b48d315958236531e8f8d8550"
    sha256 cellar: :any, big_sur:       "114cce72e22c5eb713f56b9f91a076b2f2d5930152d3638a95c6decee511aa3e"
    sha256 cellar: :any, catalina:      "2d1e91b5127f66e7941790c004817c94c892725c88f84f1e4c37297fcbc0c72f"
    sha256 cellar: :any, mojave:        "b6069459c78f18045ee922ce5cb5b235d4b479597d79c3c298d09e0de3d70794"
    sha256 cellar: :any, high_sierra:   "0720bd47f020d5ca895ae79eb61623ed3c7de0d4c4f221613105f47147aec01f"
  end

  keg_only :provided_by_macos, "macOS provides libicucore.dylib (but nothing else)"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-samples
      --disable-tests
      --enable-static
      --with-library-bits=64
    ]

    cd "source" do
      system "./configure", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/gendict", "--uchars", "/usr/share/dict/words", "dict"
  end
end
