class Nift < Formula
  desc "Cross-platform open source framework for managing and generating websites"
  homepage "https://nift.dev/"
  url "https://github.com/nifty-site-manager/nsm/archive/v2.3.11.tar.gz"
  sha256 "7819d70d6a4136896409e627bcfac0726d9e5f9a21fac80529f97661c71318d3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:     "fd954d10e59e79bdeea45897fc6691cd7f06497c4398ec0f1f7adae62869fc01"
    sha256 cellar: :any_skip_relocation, catalina:    "f08a936baa0f3e81ec0aa8343fb4970c39a7c73b308bad8df4e21fd665320ade"
    sha256 cellar: :any_skip_relocation, mojave:      "56e8f7ea837fbff3d3a887bd57134364c55f352c0c4e9a5bf38301dbb7e4bdda"
    sha256 cellar: :any_skip_relocation, high_sierra: "ad7c89b1c61ba4659dff5fb3b021b3283f253e158ed72830b0598afdc33198c8"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    mkdir "empty" do
      system "#{bin}/nsm", "init", ".html"
      assert_predicate testpath/"empty/output/index.html", :exist?
    end
  end
end
