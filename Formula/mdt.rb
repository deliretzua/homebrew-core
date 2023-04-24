class Mdt < Formula
  desc "Command-line markdown todo list manager"
  homepage "https://github.com/basilioss/mdt"
  url "https://github.com/basilioss/mdt/archive/refs/tags/1.3.0.tar.gz"
  sha256 "ecab59171051673e89fb1eb8964d00a6bcfc337200a913446552a0822ceb3f17"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ed1819515c70d8eb3c2bf778d6a52ce8da1e399527c429257f52ba8dcbc13c25"
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
