class Rojo < Formula
  desc "Professional grade Roblox development tools"
  homepage "https://rojo.space/"
  url "https://github.com/rojo-rbx/rojo/archive/refs/tags/v7.3.0.tar.gz"
  sha256 "849626d5395ccc58de04c4d6072c905880432c58bb2dc71ca27ab7f794b82187"
  license "MPL-2.0"
  head "https://github.com/rojo-rbx/rojo.git", branch: "master"

  depends_on "rust" => :build
  depends_on "wally" => :build

  def install
    system "wally", "install", "--project-path", "./plugin"
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"rojo", "init"
    assert_predicate testpath/"default.project.json", :exist?

    assert_match version.to_s, shell_output(bin/"rojo --version")
  end
end
