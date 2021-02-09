class GitGui < Formula
  desc "Tcl/Tk UI for the git revision control system"
  homepage "https://git-scm.com"
  # NOTE: Please keep these values in sync with git.rb when updating.
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.30.1.tar.xz"
  sha256 "f988a8a095089978dab2932af4edb22b4d7d67d67b81aaa1986fa29ef45d9467"
  license "GPL-2.0"
  head "https://github.com/git/git.git", shallow: false

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "045a1afff977d4973f123b1088567fe15b4d4f9c70beff602c4101aa1816e499"
    sha256 cellar: :any_skip_relocation, big_sur:       "27a0f42ff0d90bdfe57eff9a5077049303722c7ca25be401dd5dafbe1eff3cfe"
    sha256 cellar: :any_skip_relocation, catalina:      "39ac88d194e39f15648b2c0a5667e04666b40c003d3d64dc21ed6e46db56437f"
    sha256 cellar: :any_skip_relocation, mojave:        "9ec9d216c68fe11fa2f36c0f62e5f995836745d373a3521f6d87f418610c75dc"
  end

  depends_on "tcl-tk"

  # Patch to fix Homebrew/homebrew-core#68798.
  # Remove when the following PR has been merged
  # and included in a release:
  # https://github.com/git/git/pull/944
  patch do
    url "https://github.com/git/git/commit/1db62e44b7ec93b6654271ef34065b31496cd02e.patch?full_index=1"
    sha256 "0c7816ee9c8ddd7aa38aa29541c9138997650713bce67bdef501b1de0b50f539"
  end

  def install
    # build verbosely
    ENV["V"] = "1"

    # By setting TKFRAMEWORK to a non-existent directory we ensure that
    # the git makefiles don't install a .app for git-gui
    # We also tell git to use the homebrew-installed wish binary from tcl-tk.
    # See https://github.com/Homebrew/homebrew-core/issues/36390
    tcl_bin = Formula["tcl-tk"].opt_bin
    args = %W[
      TKFRAMEWORK=/dev/null
      prefix=#{prefix}
      gitexecdir=#{bin}
      sysconfdir=#{etc}
      CC=#{ENV.cc}
      CFLAGS=#{ENV.cflags}
      LDFLAGS=#{ENV.ldflags}
      TCL_PATH=#{tcl_bin}/tclsh
      TCLTK_PATH=#{tcl_bin}/wish
    ]
    system "make", "-C", "git-gui", "install", *args
    system "make", "-C", "gitk-git", "install", *args
  end

  test do
    system bin/"git-gui", "--version"
  end
end
