class Mdt < Formula
  desc "Command-line markdown todo list manager"
  homepage "https://github.com/basilioss/mdt"
  url "https://github.com/basilioss/mdt/archive/refs/tags/1.2.0.tar.gz"
  sha256 "fe8d1cb2b5818895cf1b514dd8f76bb28fcb9aab6178acbf4615a07f690c7f15"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8c5242c00dd94dd0421af16d5626c50885666cca44968b7f54224e1e273cd76a"
  end

  depends_on "gum"

  def install
    bin.install "mdt"
  end

  test do
    assert_equal "mdt #{version}", shell_output("#{bin}/mdt --version").chomp
    assert_match "Error: Got an unexpected argument '--invalid'.", shell_output("#{bin}/mdt --invalid 2>&1", 1)
  end
end
