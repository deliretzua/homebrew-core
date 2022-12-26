class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.20.0.tgz"
  sha256 "79612d90ca49c14b9a1307d681003d7f72403324ff63cae53467abf66a386924"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7671757f7054e7ec3186eb02920e3460e80cb79119a31827610fd528f73431e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7671757f7054e7ec3186eb02920e3460e80cb79119a31827610fd528f73431e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7671757f7054e7ec3186eb02920e3460e80cb79119a31827610fd528f73431e"
    sha256 cellar: :any_skip_relocation, ventura:        "f3476d75685ac79114a46b43df00f762f1d61168d88775f6ee60f1d02f18044c"
    sha256 cellar: :any_skip_relocation, monterey:       "f3476d75685ac79114a46b43df00f762f1d61168d88775f6ee60f1d02f18044c"
    sha256 cellar: :any_skip_relocation, big_sur:        "d09e7d386e9ad499a7e40b8503b8bae5d5f1e838093a302fab68bf7ce22fbc38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7671757f7054e7ec3186eb02920e3460e80cb79119a31827610fd528f73431e"
  end

  depends_on "node" => :test

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  def install
    libexec.install buildpath.glob("*")
    bin.install_symlink "#{libexec}/bin/pnpm.cjs" => "pnpm"
    bin.install_symlink "#{libexec}/bin/pnpx.cjs" => "pnpx"
  end

  def caveats
    <<~EOS
      pnpm requires a Node installation to function. You can install one with:
        brew install node
    EOS
  end

  test do
    system "#{bin}/pnpm", "init"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
