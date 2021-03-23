class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://sqlite.org/2021/sqlite-src-3350200.zip"
  version "3.35.2"
  sha256 "6af39632ed596ff3294f35caff4d671745f81894135f9789ceecf696dfc38703"
  license "blessing"

  livecheck do
    url "https://sqlite.org/news.html"
    regex(%r{v?(\d+(?:\.\d+)+)</h3>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f9c6846623d6f94989c17fd33131393d2bc7a8fb336e5598eb326e94b956b584"
    sha256 cellar: :any_skip_relocation, big_sur:       "ae802d2735142bad1b231ae31a4bfd5bfe8a78a9ac7bfbe68afdc9f2a08880ed"
    sha256 cellar: :any_skip_relocation, catalina:      "28f56212edcb23f49f8f1d86b1f1b434f7a5b3b03f9d8eba5ba19085ad67c991"
    sha256 cellar: :any_skip_relocation, mojave:        "6ddccf007a69ef3b632906e5eaca40686de76e819a816d26b2feca69926627a3"
  end

  uses_from_macos "tcl-tk" => :build
  uses_from_macos "sqlite" => :test

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "sqldiff"
    bin.install "sqldiff"
  end

  test do
    dbpath = testpath/"test.sqlite"
    sqlpath = testpath/"test.sql"
    sqlpath.write "create table test (name text);"
    system "/usr/bin/sqlite3 #{dbpath} < #{sqlpath}"
    assert_equal "test: 0 changes, 0 inserts, 0 deletes, 0 unchanged",
                 shell_output("#{bin}/sqldiff --summary #{dbpath} #{dbpath}").strip
  end
end
