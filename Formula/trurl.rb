class Trurl < Formula
  desc "Command-line tool for URL parsing and manipulation"
  homepage "https://github.com/curl/trurl"
  url "https://github.com/curl/trurl/archive/refs/tags/trurl-0.2.tar.gz"
  sha256 "acef7d251fc13fc97153d5d6949b50744a5bad8aa93840b0d8509cd754ed704f"
  license "curl"
  head "https://github.com/curl/trurl.git", branch: "master"

  uses_from_macos "curl", since: :ventura # uses CURLUE_NO_ZONEID, available since curl 7.81.0

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_equal "https 443 /hello.html",
      shell_output("#{bin}/trurl https://example.com/hello.html --get '{scheme} {port} {path}'").chomp
  end
end
