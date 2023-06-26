class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.6.4.tgz"
  sha256 "f05d50a7b133e1beb31cc7ddba43d856507d790bcac9b600b8a4fa4f346c8de5"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8eea423e91251f24debd1e5edf1533893e532a5316aea8e936033701f37da66b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8eea423e91251f24debd1e5edf1533893e532a5316aea8e936033701f37da66b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8eea423e91251f24debd1e5edf1533893e532a5316aea8e936033701f37da66b"
    sha256 cellar: :any_skip_relocation, ventura:        "76098279506e379e30b8e77c34f6bde7ef4f483cf4657b4857b07beabe6e1bf0"
    sha256 cellar: :any_skip_relocation, monterey:       "76098279506e379e30b8e77c34f6bde7ef4f483cf4657b4857b07beabe6e1bf0"
    sha256 cellar: :any_skip_relocation, big_sur:        "be7551e890cc00513c898eceebde354af90678225b00b34f92c33c4345b818ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8eea423e91251f24debd1e5edf1533893e532a5316aea8e936033701f37da66b"
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
