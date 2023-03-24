class Borgbackup < Formula
  include Language::Python::Virtualenv

  desc "Deduplicating archiver with compression and authenticated encryption"
  homepage "https://borgbackup.org/"
  url "https://files.pythonhosted.org/packages/6e/9e/e7a116401ef0c6c2766e4e49e5a3aafaa725ba0ea827305f016339c6c496/borgbackup-1.2.4.tar.gz"
  sha256 "a4bd54e9469e81b7a30a6711423115abc818d9cd844ecb1ca0e6104bc5374da8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3a069c33502097749b1b8604357f69f665c0c5016ee6e1d4d370086ed768e9ab"
    sha256 cellar: :any,                 arm64_monterey: "b486d5311ef4f959c002dc04ec79f92b0c4206b469a3f6eef29eed7531d7b48c"
    sha256 cellar: :any,                 arm64_big_sur:  "bfc65d6a17d0f01bb8b6e251bd17831697bdeaa30f1c554ae633db46d1f93158"
    sha256 cellar: :any,                 ventura:        "4e4de3172980c24b8d75ff2db69ec02ec42f6336fef69b465f37e1999535df38"
    sha256 cellar: :any,                 monterey:       "b1f1ceb713e64dcbf9a3d2daf9ceb837e1207bbc6389ee5eb5a56c75a9d52fa5"
    sha256 cellar: :any,                 big_sur:        "8a729b30ee56fbe9c11897b7e3bbb53e12cc4e14767ccae7e5af05f0d83cc55d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "728fbbd77f97a94586b30379ddb48732aeedd2c49a3b496ef7d53ec6cec89dba"
  end

  depends_on "pkg-config" => :build
  depends_on "libb2"
  depends_on "lz4"
  depends_on "openssl@1.1"
  depends_on "python@3.11"
  depends_on "xxhash"
  depends_on "zstd"

  on_linux do
    depends_on "acl"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/dc/a1/eba11a0d4b764bc62966a565b470f8c6f38242723ba3057e9b5098678c30/msgpack-1.0.5.tar.gz"
    sha256 "c075544284eadc5cddc70f4757331d99dcbc16b2bbd4849d15f8aae4cf36d31c"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  def install
    ENV["BORG_LIBB2_PREFIX"] = Formula["libb2"].prefix
    ENV["BORG_LIBLZ4_PREFIX"] = Formula["lz4"].prefix
    ENV["BORG_LIBXXHASH_PREFIX"] = Formula["xxhash"].prefix
    ENV["BORG_LIBZSTD_PREFIX"] = Formula["zstd"].prefix
    ENV["BORG_OPENSSL_PREFIX"] = Formula["openssl@1.1"].prefix
    virtualenv_install_with_resources

    man1.install Dir["docs/man/*.1"]
    bash_completion.install "scripts/shell_completions/bash/borg"
    fish_completion.install "scripts/shell_completions/fish/borg.fish"
    zsh_completion.install "scripts/shell_completions/zsh/_borg"
  end

  test do
    # Create a repo and archive, then test extraction.
    cp test_fixtures("test.pdf"), testpath
    Dir.chdir(testpath) do
      system "#{bin}/borg", "init", "-e", "none", "test-repo"
      system "#{bin}/borg", "create", "--compression", "zstd", "test-repo::test-archive", "test.pdf"
    end
    mkdir testpath/"restore" do
      system "#{bin}/borg", "extract", testpath/"test-repo::test-archive"
    end
    assert_predicate testpath/"restore/test.pdf", :exist?
    assert_equal File.size(testpath/"restore/test.pdf"), File.size(testpath/"test.pdf")
  end
end
