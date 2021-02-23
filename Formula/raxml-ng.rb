class RaxmlNg < Formula
  desc "RAxML Next Generation: faster, easier-to-use and more flexible"
  homepage "https://sco.h-its.org/exelixis/web/software/raxml/"
  url "https://github.com/amkozlov/raxml-ng.git",
      tag:      "1.0.2",
      revision: "411611611793e53c992717d869ca64370f2e4789"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, big_sur:     "0e6a2372feba1e4db0627fa823d65bb31e83f8da4debf1a0a7a7c47e5283a04d"
    sha256 cellar: :any, catalina:    "4d7397bf30c609cb53ca946d398d14fadb6e7ade0bfd4b427fb0fd0a6385df95"
    sha256 cellar: :any, mojave:      "2851487308922e7bad8c5c9364cdd81318d2982cd76458b55eeeee8c50e5f693"
    sha256 cellar: :any, high_sierra: "0da342f7d906f920117cecdacd93368fcedc88ca6e8b362ebc34697e8d489f2a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "gmp"
  depends_on "open-mpi"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  resource "example" do
    url "https://sco.h-its.org/exelixis/resource/download/hands-on/dna.phy"
    sha256 "c2adc42823313831b97af76b3b1503b84573f10d9d0d563be5815cde0effe0c2"
  end

  def install
    args = std_cmake_args + ["-DUSE_GMP=ON"]
    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
    mkdir "build_mpi" do
      ENV["CC"] = "mpicc"
      ENV["CXX"] = "mpicxx"
      system "cmake", "..", *args, "-DUSE_MPI=ON", "-DRAXML_BINARY_NAME=raxml-ng-mpi"
      system "make", "install"
    end
  end

  test do
    testpath.install resource("example")
    system "#{bin}/raxml-ng", "--msa", "dna.phy", "--start", "--model", "GTR"
  end
end
