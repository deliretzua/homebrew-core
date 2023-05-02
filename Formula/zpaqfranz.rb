class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/58.2.tar.gz"
  sha256 "7b66c94bb22ff03205777c0be0e70747a0f7ef8eff9b99e2b1ac384aa495977f"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :url
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0bef53ae17206bed5dce3ec443a1f611157133dd841c984fbcb23ffc3a8545d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e308f03281301a4cb56a6c432c253521f776f61bd40194eafcf50ab06061816"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73b7e69a62b70769cde9407431cf529cab09894c5a7cad7d0fb4fa7213c176a2"
    sha256 cellar: :any_skip_relocation, ventura:        "296d7c6c32febf879490a5b854cfd266746100f38603ce91aada3e13dfa231b8"
    sha256 cellar: :any_skip_relocation, monterey:       "5a7078257b14dae4d22d4d563bcb983c580a28718ba068cc485cfb2bd21f137b"
    sha256 cellar: :any_skip_relocation, big_sur:        "13ed30b4cf87c0f341c2c88d7b105c9610c9e60e9c6524d8413f5650eff4339b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ada8e2725825db710b34e3bd86bf4b9231071bfb61b774e5ea4bbcf504bfcf4c"
  end

  def install
    bin.mkdir

    # JIT only works on Intel (might work on Linux aarch64, but not Apple Silicon)
    ENV.append_to_cflags "-DNOJIT" unless Hardware::CPU.intel?

    system "make", "install", "-f", "NONWINDOWS/Makefile", "BINDIR=#{bin}/#{name}"
    man1.install Utils::Gzip.compress("man/zpaqfranz.1")
  end

  test do
    system bin/"zpaqfranz", "autotest", "-to", testpath/"archive"
    system bin/"zpaqfranz", "extract", testpath/"archive/sha256.zpaq", "-to", testpath/"out/"
    testpath.glob("out/*").each do |path|
      assert_equal path.basename.to_s.downcase, Digest::SHA256.hexdigest(path.read)
    end
  end
end
