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
    sha256               big_sur:  "5c46c04b6cef3416d7fd895b11c1e63be6df785995462f483321f8d279ee347c"
    sha256 cellar: :any, catalina: "23c23e1e940dc42109b08ce5e0ea0f32f2cdf4875cc276f19d5602a9d976d644"
    sha256 cellar: :any, mojave:   "aa32c14b7dd52792cbe7272aa4951745a80ad44e441bf0a85e4aab9f4643a9f4"
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
