class Jbang < Formula
  desc "Tool to create, edit and run self-contained source-only Java programs"
  homepage "https://jbang.dev/"
  url "https://github.com/jbangdev/jbang/releases/download/v0.103.0/jbang-0.103.0.zip"
  sha256 "16ac5386f24fb2e8753f59553870ee9d36d89b6d236d87c855c35ff422a5b376"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "afdb29bb1a1f9b7610149a92e6eb73b57b0388a1a6756e0bba612d079201dfcb"
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
