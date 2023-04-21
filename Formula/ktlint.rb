class Ktlint < Formula
  desc "Anti-bikeshedding Kotlin linter with built-in formatter"
  homepage "https://ktlint.github.io/"
  url "https://github.com/pinterest/ktlint/releases/download/0.49.0/ktlint"
  sha256 "df031c421a52240ffab762b742a10d9772d73eb8e0fbfcbc2f9786541631a0ee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0db5324c35083f5f0aae04bac4b4496dc5716fa9e6030055855ba5cda9893816"
  end

  depends_on "openjdk"

  def install
    libexec.install "ktlint"
    (libexec/"ktlint").chmod 0755
    (bin/"ktlint").write_env_script libexec/"ktlint", Language::Java.java_home_env
  end

  test do
    (testpath/"Main.kt").write <<~EOS
      fun main( )
    EOS
    (testpath/"Out.kt").write <<~EOS
      fun main()
    EOS
    system bin/"ktlint", "-F", "Main.kt"
    assert_equal shell_output("cat Main.kt"), shell_output("cat Out.kt")
  end
end
