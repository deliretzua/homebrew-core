class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.144.0.tar.gz"
  sha256 "03d5ff09e9505cd05d539e64896cdc95d0e1b8c14603e47e9a8b6a5db26e075c"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "ed7591c2b30b994c4f03168784b97fcc2579302a23507e3e5ce5b0e9b757a43a"
    sha256 cellar: :any_skip_relocation, catalina: "d6357e19879492919b6fc7c9df110bed739cbb6e6d37e3fde151844989e1854b"
    sha256 cellar: :any_skip_relocation, mojave:   "48a9c385011270b810f1a1d8e95a79f0851ff336918451dd6cae43f37ecb1f2f"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

  def install
    system "make", "all-homebrew"

    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system "#{bin}/flow", "init", testpath
    (testpath/"test.js").write <<~EOS
      /* @flow */
      var x: string = 123;
    EOS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
