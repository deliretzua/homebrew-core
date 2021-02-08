class Stgit < Formula
  desc "Manage Git commits as a stack of patches"
  homepage "https://stacked-git.github.io"
  url "https://github.com/stacked-git/stgit/releases/download/v1.0/stgit-1.0.tar.gz"
  sha256 "c2a26b2e6a8fe2eb9c8aa4ade6d6dd35858137c381448b6142c4d2c142b47b94"
  license "GPL-2.0"
  head "https://github.com/stacked-git/stgit.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bae3ca168b90a76260511f1e54b32bbb1534bb987ce3cd33516a6375cc5b0716"
    sha256 cellar: :any_skip_relocation, big_sur:       "2f50630b1249e5340768702184e7c713af8cf97c09a3b06963a11163f439a5b8"
    sha256 cellar: :any_skip_relocation, catalina:      "9731655f9bd99aea5170be4862f2857a630f711fba241bdc87898916914c6634"
    sha256 cellar: :any_skip_relocation, mojave:        "f1352a1dbdfefd630ac1a5e6018858225cf06988305b71605a8799d54fc5972c"
    sha256 cellar: :any_skip_relocation, high_sierra:   "b6d112ee69bc0c131240ad47e53ba22500a0c595fc499a1b48b4b3beba785e2f"
  end

  depends_on "asciidoc" => :build
  depends_on "xmlto" => :build
  depends_on "python@3.9"

  def install
    ENV["PYTHON"] = Formula["python@3.9"].opt_bin/"python3"
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "make", "prefix=#{prefix}", "all"
    system "make", "prefix=#{prefix}", "install"
    system "make", "prefix=#{prefix}", "install-doc"
    bash_completion.install "completion/stgit.bash"
    fish_completion.install "completion/stg.fish"
    zsh_completion.install "completion/stgit.zsh" => "_stgit"
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "brew@test.bot"
    (testpath/"test").write "test"
    system "git", "add", "test"
    system "git", "commit", "--message", "Initial commit", "test"
    system "#{bin}/stg", "--version"
    system "#{bin}/stg", "init"
    system "#{bin}/stg", "new", "-m", "patch0"
    (testpath/"test").append_lines "a change"
    system "#{bin}/stg", "refresh"
    system "#{bin}/stg", "log"
  end
end
