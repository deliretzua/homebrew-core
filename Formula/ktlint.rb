class Ktlint < Formula
  desc "Anti-bikeshedding Kotlin linter with built-in formatter"
  homepage "https://ktlint.github.io/"
  url "https://github.com/pinterest/ktlint/releases/download/0.46.0/ktlint"
  sha256 "6d6e06a189fd095e4128ce32b6033dd916a5c8a1d4186dff829acde4adc0df2d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "022f512313df7bde00ece207961330fc93c71e08e10b58d5b1c3afa04bfa7ed0"
  end

  depends_on "openjdk@11"

  def install
    libexec.install "ktlint"
    (libexec/"ktlint").chmod 0755
    (bin/"ktlint").write_env_script libexec/"ktlint",
                                    Language::Java.java_home_env("11").merge(
                                      PATH: "#{Formula["openjdk@11"].opt_bin}:${PATH}",
                                    )
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
