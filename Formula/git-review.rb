class GitReview < Formula
  include Language::Python::Virtualenv

  desc "Submit git branches to gerrit for review"
  homepage "https://opendev.org/opendev/git-review"
  url "https://files.pythonhosted.org/packages/8e/5c/18f534e16b193be36d140939b79a8046e07f343b426054c084b12d59cf0b/git-review-2.3.1.tar.gz"
  sha256 "24e938136eecb6e6cbb38b5e2b034a286b70b5bb8b5a2853585c9ed23636014f"
  license "Apache-2.0"
  revision 1
  head "https://opendev.org/opendev/git-review.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aec600d1ce6131f87c33a515b64c481c36a8a644ae5131c026e560d8ec7e8aa7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f130a29f33f17c022bce927080a90e78ae5f64fd91b3274e5eec37592081a05c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24d576e73718c5a4d8a14ee065d0dc6c7e5054824b519553fbb3dd7df30a3c20"
    sha256 cellar: :any_skip_relocation, ventura:        "9d533cb0d6478bdb9b30538ae9f72cf9ea615c5348daf044f25546c31c724662"
    sha256 cellar: :any_skip_relocation, monterey:       "abf637a8cdc8f51c6c78cc2c4554dd74b671096c554aa44f53932ad484dfc641"
    sha256 cellar: :any_skip_relocation, big_sur:        "24a52add0ebfa654fe674c39f5b4805c7b7dea61cebc0f98a5e6adaaf3a35782"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecc42052b10b312a56bdf5a25e67e53a8748431573fe1a67a9eaf7600fb57d69"
  end

  depends_on "python@3.11"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/98/98/c2ff18671db109c9f10ed27f5ef610ae05b73bd876664139cf95bd1429aa/certifi-2023.7.22.tar.gz"
    sha256 "539cc1d13202e33ca466e88b2807e29f4c13049d6d87031a3c110744495cb082"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
  end

  def install
    virtualenv_install_with_resources
    man1.install Utils::Gzip.compress("git-review.1")
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    system "git", "remote", "add", "gerrit", "https://github.com/Homebrew/brew.sh"
    (testpath/".git/hooks/commit-msg").write "# empty - make git-review happy"
    (testpath/"foo").write "test file"
    system "git", "add", "foo"
    system "git", "commit", "-m", "test"
    system "#{bin}/git-review", "--dry-run"
  end
end
