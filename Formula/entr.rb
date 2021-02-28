class Entr < Formula
  desc "Run arbitrary commands when files change"
  homepage "https://eradman.com/entrproject/"
  url "https://eradman.com/entrproject/code/entr-4.8.tar.gz"
  sha256 "f05555cd745b7dc67b61a98cf79971125b7e43931a5772d5bce2d891327425ae"
  license "ISC"
  head "https://github.com/eradman/entr.git"

  livecheck do
    url "https://eradman.com/entrproject/code/"
    regex(/href=.*?entr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "382670926073b72a8a4661c3dbeda426bd525ec0d671095ed57e297b0cb85711"
    sha256 cellar: :any_skip_relocation, big_sur:       "619e035bd88e1022abe8ea2bb47872d8d9bb0ce48774d316b20d78ed236cdcb6"
    sha256 cellar: :any_skip_relocation, catalina:      "c2f8633d2f84a9f1b0b06fe49d8bf09ca07c4ca3b386b0111c1ab14609d28fa7"
    sha256 cellar: :any_skip_relocation, mojave:        "667d0ba4094590eb0c24db62a35b467b58a2a5899b2419b05d8d49dd8f22fd15"
  end

  def install
    ENV["PREFIX"] = prefix
    ENV["MANPREFIX"] = man
    system "./configure"
    system "make"
    system "make", "install"
  end

  test do
    touch testpath/"test.1"
    fork do
      sleep 0.5
      touch testpath/"test.2"
    end
    assert_equal "New File", pipe_output("#{bin}/entr -p -d echo 'New File'", testpath).strip
  end
end
