class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/arrow-datafusion/archive/refs/tags/5.0.0.tar.gz"
  sha256 "7ba05bba8b7ea3b1f7ff6b3d1b1a3413a81540c57342ef331d51a07ad4a7b7a8"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "94dda735ac09c8bd22d6d834c5c63eec0ddd255a8b3b52754e5ddc98f120c2a5"
    sha256 cellar: :any_skip_relocation, big_sur:       "9ecc8a01be47ceb9a53b39976696afa87c0a85e81a59d40de170047684a3a692"
    sha256 cellar: :any_skip_relocation, catalina:      "58eb797586e94e80f2df63d160d5b166cf1c1b86be601018a54134d060175546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7ec8d683cdf7f532d2ec22ebdcb9ea40cfd2ee95e5ae4a855805ef3bf98741f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "datafusion-cli")
  end

  test do
    (testpath/"datafusion_test.sql").write("select 1+2 as n;")
    assert_equal "[{\"n\":3}]", shell_output("#{bin}/datafusion-cli -q --format json -f datafusion_test.sql").strip
  end
end
