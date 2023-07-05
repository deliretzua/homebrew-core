class H2 < Formula
  desc "Java SQL database"
  homepage "https://www.h2database.com/"
  url "https://github.com/h2database/h2database/releases/download/version-2.2.220/h2-2023-07-04.zip"
  version "2.2.220"
  sha256 "f461dce80bc055c5ec7652c31249d7639a780e046e3974e45ee0ab79e7a36812"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fa5d5febd18e101ce73f94cab8a2c41d126dd0acbfd6386de14a85ed0b40671b"
  end

  depends_on "openjdk"

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    # Fix the permissions on the script
    # upstream issue, https://github.com/h2database/h2database/issues/3254
    chmod 0755, "bin/h2.sh"

    libexec.install Dir["*"]
    (bin/"h2").write_env_script libexec/"bin/h2.sh", Language::Java.overridable_java_home_env
  end

  service do
    run [opt_bin/"h2", "-tcp", "-web", "-pg"]
    keep_alive false
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match "Usage: java org.h2.tools.GUIConsole", shell_output("#{bin}/h2 -help 2>&1")
  end
end
