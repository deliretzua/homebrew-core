class Jpegoptim < Formula
  desc "Utility to optimize JPEG files"
  homepage "https://github.com/tjko/jpegoptim"
  url "https://github.com/tjko/jpegoptim/archive/v1.5.4.tar.gz"
  sha256 "8fc7537f722d533ea8b45966ab80c83e3342d088d5a690fdadfb05b7c9cba47f"
  license "GPL-3.0-or-later"
  head "https://github.com/tjko/jpegoptim.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ad500f2fb30d2217f72af4b131571d6fa7cd98c61be8c585a6477cf21538f031"
    sha256 cellar: :any,                 arm64_monterey: "76b5a0ea886b0a021420c55d22a615a1113e6d9d106d4175aa858e9467dae902"
    sha256 cellar: :any,                 arm64_big_sur:  "5f20eaae27de467ce9c8977ea8900bbff361bedeeb75b9ffb7cd970b253d06c4"
    sha256 cellar: :any,                 ventura:        "5e7a7c005f27280f6b994d2ee124cbb3a14fc1eda0e782a9e080a8dcc2bca0ce"
    sha256 cellar: :any,                 monterey:       "e5648c7b4ff0fae543ff422cb4323eb9cfac344d2bc5a1320b54f792eb43a24d"
    sha256 cellar: :any,                 big_sur:        "2b3bb6f6e56f46b5fb999839e9b1dae731c52c33657be0ce7b623efb9bf8fbb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e41a044bc8811107483210b120b743d659cc29847f60da83fff8dd78d5306673"
  end

  depends_on "jpeg-turbo"

  def install
    system "./configure", *std_configure_args
    ENV.deparallelize # Install is not parallel-safe
    system "make", "install"
  end

  test do
    source = test_fixtures("test.jpg")
    assert_match "OK", shell_output("#{bin}/jpegoptim --noaction #{source}")
  end
end
