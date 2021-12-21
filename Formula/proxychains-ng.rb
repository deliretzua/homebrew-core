class ProxychainsNg < Formula
  desc "Hook preloader"
  homepage "https://sourceforge.net/projects/proxychains-ng/"
  url "https://github.com/rofl0r/proxychains-ng/archive/v4.15.tar.gz"
  sha256 "c94edded38baa0447766f6e5d0ec1963bb27c7b55b2a78b305d6f58e171388f8"
  license "GPL-2.0-or-later"
  head "https://github.com/rofl0r/proxychains-ng.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "3d9160bad88b034c0cafa375ce9c8b0f1ad727ca13952ce6622c85e23b3c28c9"
    sha256 arm64_big_sur:  "389c32c6e5a4a5226812a2b0136ec040f909580b144140594445327e2fc2ebbf"
    sha256 monterey:       "63b4f0288b83e6b0cf9ab1a340d5196606c54bca403eaf29930cc315e7d2929b"
    sha256 big_sur:        "168ca0ce8129eb8739bebf9ddea8cbc7ca594a18ec96c3d70a5e9a5868e3b7d8"
    sha256 catalina:       "1b8b781209633d9c4c45249b78865311e9853c36ba8522146a95cf4793d166b1"
    sha256 mojave:         "4b41340fc2a68c579b3ab30affbe82f9be545537f727507d19977b1b67193a96"
    sha256 high_sierra:    "42ba51b1578ff901987212d74e8b3a83ec6313f5ccfe3d554a9b32766f9b65c4"
    sha256 sierra:         "4c8e8c69bd10529a33b3f70e1a55504f79e3358fe834d521c95adafb2f4eea4a"
    sha256 x86_64_linux:   "017e3132cf30e9d01e736d96e17201671cbf7bc3a802a7c842e663b36082714d"
  end

  # Fix regression in detecting linker options, resulting in build failure for v4.15
  # Patch included upstream, remove on next release
  patch do
    url "https://github.com/rofl0r/proxychains-ng/commit/7de7dd0de1ff387a627620ac3482b4cd9b3fba95.patch?full_index=1"
    sha256 "dd38fec48f675e17207e320d6f708d7c0c747de57cdd8aafb59bbb0ab805a984"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make"
    system "make", "install"
    system "make", "install-config"
  end

  test do
    assert_match "config file found", shell_output("#{bin}/proxychains4 test 2>&1", 1)
  end
end
