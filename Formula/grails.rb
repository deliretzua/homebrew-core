class Grails < Formula
  desc "Web application framework for the Groovy language"
  homepage "https://grails.org"
  url "https://github.com/grails/grails-core/releases/download/v5.0.0/grails-5.0.0.zip"
  sha256 "78f85854439b9f8ef3df630578ebe3b0f7a34814d0bdd22ec8f183c1b465c543"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4799764c46874cafe31135e5aacd2eb34bc0ea92c9cdcc91b4bfc4af05fd15f0"
    sha256 cellar: :any_skip_relocation, big_sur:       "4799764c46874cafe31135e5aacd2eb34bc0ea92c9cdcc91b4bfc4af05fd15f0"
    sha256 cellar: :any_skip_relocation, catalina:      "4799764c46874cafe31135e5aacd2eb34bc0ea92c9cdcc91b4bfc4af05fd15f0"
    sha256 cellar: :any_skip_relocation, mojave:        "4799764c46874cafe31135e5aacd2eb34bc0ea92c9cdcc91b4bfc4af05fd15f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9aa2b0415a25eb1e13b710234dfe3e30aec2db5c1a6c313bcc273c99132afc0d"
  end

  depends_on "openjdk@11"

  def install
    rm_f Dir["bin/*.bat", "bin/cygrails", "*.bat"]
    libexec.install Dir["*"]
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env("11")
  end

  def caveats
    <<~EOS
      The GRAILS_HOME directory is:
        #{opt_libexec}
    EOS
  end

  test do
    system bin/"grails", "create-app", "brew-test"
    assert_predicate testpath/"brew-test/gradle.properties", :exist?
    assert_match "brew.test", File.read(testpath/"brew-test/build.gradle")

    assert_match "Grails Version: #{version}", shell_output("#{bin}/grails -v")
  end
end
