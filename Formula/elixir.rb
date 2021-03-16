class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.11.4.tar.gz"
  sha256 "85c7118a0db6007507313db5bddf370216d9394ed7911fe80f21e2fbf7f54d29"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dc94bf65bccb57f6794c8bb081faa5914cc7184a6ecf71c8ce904cb91331445a"
    sha256 cellar: :any_skip_relocation, big_sur:       "a06541e028cdd23af796aacb0c4217828a4066eb9239f414250937dd7d7775e8"
    sha256 cellar: :any_skip_relocation, catalina:      "e0ff8e34210c0c1bc477b225b2cf3edfcafa82d2a1dcf071d1da49a51758003a"
    sha256 cellar: :any_skip_relocation, mojave:        "dfcaa759c90179c486044fbf04e6300b2c7588e9d5169fa050fafe618415dec3"
  end

  depends_on "erlang"

  def install
    system "make"
    bin.install Dir["bin/*"] - Dir["bin/*.{bat,ps1}"]

    Dir.glob("lib/*/ebin") do |path|
      app = File.basename(File.dirname(path))
      (lib/app).install path
    end

    system "make", "install_man", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/elixir", "-v"
  end
end
