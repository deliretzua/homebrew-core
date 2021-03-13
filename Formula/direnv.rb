class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.28.0.tar.gz"
  sha256 "fa539c63034b6161d8238299bb516dcec79e8905cd43ff2b9559ad6bf047cc93"
  license "MIT"
  head "https://github.com/direnv/direnv.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0c982e714b93db8139ca8712e994bcdba19c1341132304b17d282ce1a6caa13b"
    sha256 cellar: :any_skip_relocation, big_sur:       "bf23db053d25081095366198f72f8b00ce272fd682d29e38f8af61dd3e5a61d5"
    sha256 cellar: :any_skip_relocation, catalina:      "02454d5571292dcc4520687ae721518de35deadccf7fe3b4de8eade2d19b27b1"
    sha256 cellar: :any_skip_relocation, mojave:        "6be47ea404f214c73485e722555c5f59c0a857cc553cc8a455763ac4d73f974a"
  end

  depends_on "go" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"direnv", "status"
  end
end
