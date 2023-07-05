class Blades < Formula
  desc "Blazing fast dead simple static site generator"
  homepage "https://getblades.org/"
  url "https://github.com/grego/blades/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "e9ee64ead54e1942397ea5d6fcfd6ba928a888c1f4c127b11dec9fbadd283cc2"
  license "GPL-3.0-or-later"
  head "https://github.com/grego/blades.git", branch: "master"

  depends_on "rust" => :build
  uses_from_macos "expect" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    script = (testpath/"script.exp")
    script.write <<~EOS
      #!/usr/bin/expect -f
      set timeout 2
      spawn #{bin}/blades init

      expect -exact "Name:"
      send -- "brew\r"

      expect -exact "Author:"
      send -- "test\r"

      expect eof
    EOS

    system "expect", "-f", "script.exp"
    assert_predicate testpath/"content", :exist?
    assert_match "title = \"brew\"", (testpath/"Blades.toml").read

    assert_match "blades #{version}", shell_output("#{bin}/blades --version")
  end
end
