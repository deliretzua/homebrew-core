class Jbang < Formula
  desc "Tool to create, edit and run self-contained source-only Java programs"
  homepage "https://jbang.dev/"
  url "https://github.com/jbangdev/jbang/releases/download/v0.103.2/jbang-0.103.2.zip"
  sha256 "51b24ceeacec20a4e79239df0d2901172905c96c1f667f761ae51acf7fe07b72"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ef87676d73bfd125de3b53a7294626627b26a0eaeb80ed9b4f8e9e25ed4b695b"
  end

  depends_on "openjdk"

  def install
    libexec.install "bin/jbang.jar"
    bin.write_jar_script libexec/"jbang.jar", "jbang"
  end

  test do
    system "#{bin}/jbang", "init", "--template=cli", testpath/"hello.java"
    assert_match "hello made with jbang", (testpath/"hello.java").read

    assert_match version.to_s, shell_output("#{bin}/jbang --version 2>&1")
  end
end
