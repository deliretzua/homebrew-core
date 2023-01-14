class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.25.0.tgz"
  sha256 "5da83e8c1f9f890938325ef6bcc7fcf7ff6b2b1fb401e858f7130ba2fa6b0f6e"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70f8dca9e4b5e8f1e4b705ff2e8763efd9e6bf9ef32e85cf0454b34690c10161"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70f8dca9e4b5e8f1e4b705ff2e8763efd9e6bf9ef32e85cf0454b34690c10161"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70f8dca9e4b5e8f1e4b705ff2e8763efd9e6bf9ef32e85cf0454b34690c10161"
    sha256 cellar: :any_skip_relocation, ventura:        "55bba8cc31c65b98ec096a67b6de8598c004cc245aea9c15e8385fcd11bcf009"
    sha256 cellar: :any_skip_relocation, monterey:       "55bba8cc31c65b98ec096a67b6de8598c004cc245aea9c15e8385fcd11bcf009"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9ba2c4365d20c40aee62b70445ed3d8df3ed09955cc2130e5f56c249dc61898"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70f8dca9e4b5e8f1e4b705ff2e8763efd9e6bf9ef32e85cf0454b34690c10161"
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
