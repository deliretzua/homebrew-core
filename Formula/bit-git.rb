class BitGit < Formula
  desc "Bit is a modern Git CLI"
  homepage "https://github.com/chriswalz/bit"
  url "https://github.com/chriswalz/bit/archive/v1.0.3.tar.gz"
  sha256 "4557779eea05183e3e2efed3233db56ec2fa27bc82002134a83f0ba1dcfef374"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0f0278bb553b1d02fb53bf1a18305fd031e95ef88fc39d24ddff9a5b1fdb83ad"
    sha256 cellar: :any_skip_relocation, big_sur:       "706a291c13596bdb81799fa3f8133b715c4f95f23d825bfa37d4ea91bae30995"
    sha256 cellar: :any_skip_relocation, catalina:      "5eb72f40d3862c3e44a5c5d12384a58fe013105624a3bf874f55a0164d1625ac"
    sha256 cellar: :any_skip_relocation, mojave:        "c8e8120297a38e532a3f0c48f8f5e36d83ae450b973d5224feed3bb9b6fe7048"
  end

  depends_on "go" => :build

  conflicts_with "bit", because: "both install `bit` binaries"

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.version=v#{version}"
    bin.install_symlink "bit-git" => "bit"
  end

  test do
    system "git", "init", testpath/"test-repository"

    cd testpath/"test-repository" do
      (testpath/"test-repository/test.txt").write <<~EOS
        Hello Homebrew!
      EOS
      system bin/"bit", "add", "test.txt"

      output = shell_output("#{bin}/bit status").chomp
      assert_equal "new file:   test.txt", output.lines.last.strip
    end
  end
end
