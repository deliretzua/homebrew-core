class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.24.3.tgz"
  sha256 "2d54ee6f9a73f8369c3a670d363f0bf2dc2860fe300c47c5dee0325cd98c00f9"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa831b1f25d137f7f4a318b7541e9d75d140666592a347901fc2c057c46b18e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa831b1f25d137f7f4a318b7541e9d75d140666592a347901fc2c057c46b18e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa831b1f25d137f7f4a318b7541e9d75d140666592a347901fc2c057c46b18e6"
    sha256 cellar: :any_skip_relocation, ventura:        "b4418172c3c0fc2cae9b4840a51440be6ac7c44efde96a19019c869074448e05"
    sha256 cellar: :any_skip_relocation, monterey:       "b4418172c3c0fc2cae9b4840a51440be6ac7c44efde96a19019c869074448e05"
    sha256 cellar: :any_skip_relocation, big_sur:        "133aa0dd8dd70cf5982c8858c9593fd18e2019a6033975a387215462428bc9c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa831b1f25d137f7f4a318b7541e9d75d140666592a347901fc2c057c46b18e6"
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
