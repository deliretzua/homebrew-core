class Jbang < Formula
  desc "Tool to create, edit and run self-contained source-only Java programs"
  homepage "https://jbang.dev/"
  url "https://github.com/jbangdev/jbang/releases/download/v0.106.1/jbang-0.106.1.zip"
  sha256 "8950ecb093776ec23e53ce27554a8d47223ea995e6a1b4b44b3cddf27c06de1d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fa57f3690f79c810a389bc9e0481bdfa501f7cc1cbf1b65c23859d533f990b95"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    inreplace "#{libexec}/bin/jbang", /^abs_jbang_dir=.*/, "abs_jbang_dir=#{libexec}/bin"
    bin.install_symlink libexec/"bin/jbang"
  end

  test do
    system "#{bin}/jbang", "init", "--template=cli", testpath/"hello.java"
    assert_match "hello made with jbang", (testpath/"hello.java").read
    assert_match version.to_s, shell_output("#{bin}/jbang --version 2>&1")
  end
end
