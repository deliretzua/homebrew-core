class Elfx86exts < Formula
  desc "Decodes x86 binaries (ELF and Mach-O) and prints out ISA extensions in use"
  homepage "https://github.com/pkgw/elfx86exts"
  url "https://github.com/pkgw/elfx86exts/archive/refs/tags/elfx86exts@0.5.0.tar.gz"
  sha256 "e09c3b7a08b7034859d4d56d0fbfa1d0c45b3df3d4345af51cca05d1f7d80766"
  license "MIT"
  head "https://github.com/pkgw/elfx86exts.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:elfx86exts@)?v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "rust" => :build
  depends_on "capstone"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    expected = <<~EOS
      MODE64 (call)
      CPU Generation: Intel Core
    EOS
    actual = shell_output("#{bin}/elfx86exts #{test_fixtures("elf/hello")}")
    assert_equal expected, actual
  end
end
