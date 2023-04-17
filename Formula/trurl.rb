class Trurl < Formula
  desc "Command-line tool for URL parsing and manipulation"
  homepage "https://curl.se/trurl/"
  url "https://github.com/curl/trurl/archive/refs/tags/trurl-0.5.tar.gz"
  sha256 "b5c5600cd3533e208b720f13aa06de724270d1750406b41a22f48ce95c51844d"
  license "curl"
  head "https://github.com/curl/trurl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f01af7d6379b6e93b6fa5602b289a357152475128c844d0f9904b508cb86b7f"
    sha256 cellar: :any,                 arm64_monterey: "7114fb84d28396ae1c19f4c5346328c74876e8afdccea69677482bcd177c9201"
    sha256 cellar: :any,                 arm64_big_sur:  "55b6e491b7312b657c3d95e08630dd3ac4c5570e4c8480c80c643dc5c7b84c2b"
    sha256 cellar: :any_skip_relocation, ventura:        "234518183f073ad2ab68d9d3774630a1cc9051e96c6a7ac42f4af3e192eea53d"
    sha256 cellar: :any,                 monterey:       "e40d5f777bb17ef4a35ef4fa8226d075b51555386e38a704b30066e278801495"
    sha256 cellar: :any,                 big_sur:        "d6a5e9d40f9190676884095553c7407af0d398d7ac652740558bcc7e785c0fae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50dbd17162dc9f0d0aeb8e04c7c4c1280e3eb3cd1a797c68ee1b12b53376f6fe"
  end

  uses_from_macos "curl", since: :ventura # uses CURLUE_NO_ZONEID, available since curl 7.81.0

  # Makefile: fix build with GNU Make 3.x
  # Remove on next release.
  patch do
    url "https://github.com/curl/trurl/commit/017f91cd4e89a6df4fca32602680e785149ad9c2.patch?full_index=1"
    sha256 "0fabbb8f377b4a7a7535fac1dad8a7ffb1b86ddfdf716a72f5dd636afb2fdb98"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_equal "https 443 /hello.html",
      shell_output("#{bin}/trurl https://example.com/hello.html --get '{scheme} {port} {path}'").chomp
  end
end
