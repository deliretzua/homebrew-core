class Blink < Formula
  desc "Tiniest x86-64-linux emulator"
  homepage "https://github.com/jart/blink"
  url "https://github.com/jart/blink/releases/download/1.0.0/blink-1.0.0.tar.gz"
  sha256 "09ffc3cdb57449111510bbf2f552b3923d82a983ef032ee819c07f5da924c3a6"
  license "ISC"
  head "https://github.com/jart/blink.git", branch: "master"

  depends_on "make" => :build # Needs Make 4.0+
  depends_on "pkg-config" => :build
  uses_from_macos "zlib"

  def install
    ENV.prepend_path "PATH", Formula["make"].opt_libexec/"gnubin"
    system "./configure", "--prefix=#{prefix}", "--enable-vfs"
    system "make"
    system "make", "install"
  end

  test do
    stable.stage testpath
    ENV["BLINK_PREFIX"] = testpath
    goodhello = "third_party/cosmo/goodhello.elf"
    chmod "+x", goodhello
    system bin/"blink", "-m", goodhello
  end
end
