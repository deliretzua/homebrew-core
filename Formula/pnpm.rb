class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.6.5.tgz"
  sha256 "91dd45b4762c73f58f354999867854fcbe7376235474d131080fe391f2eb5227"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d01ee3f115b651f4af1651db3bdad4616bfd34a1d64ab921059825f7c752e754"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d01ee3f115b651f4af1651db3bdad4616bfd34a1d64ab921059825f7c752e754"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d01ee3f115b651f4af1651db3bdad4616bfd34a1d64ab921059825f7c752e754"
    sha256 cellar: :any_skip_relocation, ventura:        "a759b761db9c69b721d34b95fe5c78a4ef5703d50e98d0c235aa3431df745dde"
    sha256 cellar: :any_skip_relocation, monterey:       "a759b761db9c69b721d34b95fe5c78a4ef5703d50e98d0c235aa3431df745dde"
    sha256 cellar: :any_skip_relocation, big_sur:        "25aff10315099d566fd2d78a7324b4e4f277651ec423a6356fd3165a7aee4c8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d01ee3f115b651f4af1651db3bdad4616bfd34a1d64ab921059825f7c752e754"
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
