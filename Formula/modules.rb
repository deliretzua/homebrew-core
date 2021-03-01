class Modules < Formula
  desc "Dynamic modification of a user's environment via modulefiles"
  homepage "https://modules.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/modules/Modules/modules-4.7.0/modules-4.7.0.tar.bz2"
  sha256 "68099b98f075c669af3a6eb638b75a2feefc8dd7f778bcae3f5504ded9c1b2ca"

  livecheck do
    url :stable
    regex(%r{url=.*?/modules[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 big_sur:  "b3327bf218e44bfd3b26c02ffcdd87accc74975e8133bdc8902ce8cb1f24b06b"
    sha256 catalina: "673d73d75d4d693610580f9037ae2522701b5cb418d8a79289988dbaa3229e79"
    sha256 mojave:   "219a6de0edbd5a629af151f5cb67889088cba2610a0b93c6eab74c3c9e70afa7"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --datarootdir=#{share}
      --with-tcl=#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework
      --without-x
    ]
    system "./configure", *args
    system "make", "install"
  end

  def caveats
    <<~EOS
      To activate modules, add the following at the end of your .zshrc:
        source #{opt_prefix}/init/zsh
      You will also need to reload your .zshrc:
        source ~/.zshrc
    EOS
  end

  test do
    assert_match "restore", shell_output("#{bin}/envml --help")
    output = shell_output("zsh -c 'source #{prefix}/init/zsh; module' 2>&1")
    assert_match version.to_s, output
  end
end
