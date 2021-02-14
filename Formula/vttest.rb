class Vttest < Formula
  desc "Test compatibility of VT100-compatible terminals"
  homepage "https://invisible-island.net/vttest/"
  url "https://invisible-mirror.net/archives/vttest/vttest-20210210.tgz"
  sha256 "0f98a2e305982915f1520984c3e8698e3acd508ee210711528c89f5a7ea7f046"
  license "BSD-3-Clause"

  livecheck do
    url "https://invisible-mirror.net/archives/vttest/"
    regex(/href=.*?vttest[._-]v?(\d+(?:[.-]\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "146b65073bd5cbed58ccaa43a2af7854a45a642fd81e27418b23e232a9d5126b"
    sha256 cellar: :any_skip_relocation, big_sur:       "d99c891ef72835d79954094937d025a7e78d62c7ac6daccb9f924e20cff191bd"
    sha256 cellar: :any_skip_relocation, catalina:      "67bea69b355e52582b491452592cf3e752ea8c229303b5aad91fbf79f8d943d5"
    sha256 cellar: :any_skip_relocation, mojave:        "77bdb11dde1c90472cf217f61c02e05520cfe39ad8635aaaa28a7e3bddc7e370"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output(bin/"vttest -V")
  end
end
