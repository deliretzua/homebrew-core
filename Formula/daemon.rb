class Daemon < Formula
  desc "Turn other processes into daemons"
  homepage "https://libslack.org/daemon/"
  url "https://libslack.org/daemon/download/daemon-0.8.2.tar.gz"
  sha256 "b34b37543bba43bd086e59f4b754c8102380ae5c1728b987c890d5da4b4cf3ca"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?daemon[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "695ab9b7a8d6f6ce5c1b75bcf309d59bfaafb995bf47a72c39fc906a04e94296"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b778684bf4c56ea95a896c9d72024bb76581bf9bfa0cad0cc4198e8100d170cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e96c8d9247317a551425bb4d3b5fc1702e5880c01ab7db05a1c609569017f28"
    sha256 cellar: :any_skip_relocation, ventura:        "ec2181c7ec9ad8e0b9deb4d615fc97d64ca410a16b54751235e2a1563d4a229f"
    sha256 cellar: :any_skip_relocation, monterey:       "cbc8097cfe1a96e382ee6b387ae72d35e3f7d567a74efd7b34701e9af480ab61"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a1db870d07c4a88e3fe33cb2e1eefdac23b326f4b358b625e8fe65c704b2644"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22297d1b5a59ae6cfad801df611098f02db8e9948b821b4d71733f0d908804e6"
  end

  def install
    system "./configure"
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/daemon", "--version"
  end
end
