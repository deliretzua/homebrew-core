class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://git-lfs.github.com/"
  url "https://github.com/git-lfs/git-lfs/releases/download/v3.3.0/git-lfs-v3.3.0.tar.gz"
  sha256 "964c200bb7dcd6da44cbf0cfa88575f7e48d26925f8ec86d634d3f83306a0920"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dcbda117bb2242bf45dbe5369b6b9c1b318447078e8ea82532b0eb2f6d6801eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a81d5b29d1c0203f592e8af7b25ccb95431489ffa8dc595dbb1c39f1c08cfb46"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f10c03ed48c4168d8b80164d053040452e772c978344cc485e386183de7d5c24"
    sha256 cellar: :any_skip_relocation, ventura:        "80ac2b23bad1e29e859b912f667d4220dd28626218cdf80d274ca08e06109a71"
    sha256 cellar: :any_skip_relocation, monterey:       "2ccd239da97286fa2f9702f7c2731202819a6012163906b7e599e8fb218a6c95"
    sha256 cellar: :any_skip_relocation, big_sur:        "21c75c877159acff82ada003baa3ea7d65e2774a2636f740e4cfad4ae9d2d7b5"
    sha256 cellar: :any_skip_relocation, catalina:       "c428d687c3a70defa9178fd0b287cd8766f05bf113eb6ae8ce7bcb7940751b05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43e16ee02644936dbf6d2d504b8c66cd3e0c3dd1313436e9bd253c4c051e437c"
  end

  depends_on "asciidoctor" => :build
  depends_on "go" => :build
  depends_on "ronn" => :build
  depends_on "ruby" => :build

  def install
    ENV["GIT_LFS_SHA"] = ""
    ENV["VERSION"] = version

    system "make"
    system "make", "man", "RONN=#{Formula["ronn"].bin}/ronn"

    bin.install "bin/git-lfs"
    man1.install Dir["man/man1/*.1"]
    man5.install Dir["man/man5/*.5"]
    man7.install Dir["man/man7/*.7"]
    doc.install Dir["man/html/*.html"]
  end

  def caveats
    <<~EOS
      Update your git config to finish installation:

        # Update global git config
        $ git lfs install

        # Update system git config
        $ git lfs install --system
    EOS
  end

  test do
    system "git", "init"
    system "git", "lfs", "track", "test"
    assert_match(/^test filter=lfs/, File.read(".gitattributes"))
  end
end
