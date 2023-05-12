class Ktlint < Formula
  desc "Anti-bikeshedding Kotlin linter with built-in formatter"
  homepage "https://ktlint.github.io/"
  url "https://github.com/pinterest/ktlint/releases/download/0.49.1/ktlint"
  sha256 "4044dcb054a0c124cccf37f078acaca14799efd48f611cf5ba94f8c049301bd7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "38bb7728c6b65c1b6e230d3cd5785c2fa1eece828cb1a8aee28b1633c2a3c7f8"
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
