class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.24.1.tar.gz"
  sha256 "24196f010ef2dc33e0dd419d66e5e1afc52ae508b5ee6d933aed0cc5334d15df"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "390e185fea97be80bbb27d3651ba69be39e23fc5dcdecb1e2d952733059e1dd3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07f89e87f11ff527216a89cc8dd80d13a94cab2ac88f46777ff606495b13a9c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0eaf71f601aa3b35ce9fe3018ad37e90c77855f16139e8485e1e76c8bd898a5"
    sha256 cellar: :any_skip_relocation, ventura:        "c3b62c8341a588af61dbe4745457a939bab8b613ff441fc1eb52656ff78bc0af"
    sha256 cellar: :any_skip_relocation, monterey:       "3dfa68134599b6b8acb5362091b3f777c1852265a4e50199eb42d30150dde00f"
    sha256 cellar: :any_skip_relocation, big_sur:        "553ba364b099f7e169cf1cf8b0da98972a8fa6fc0a72d77b527c40f56c348fbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a89af90534e4b0f9bbf2cec50561246a852480d7f7b1b1520fc9c4f38c9d03b"
  end

  depends_on "rust" => :build
  depends_on "libxcb"

  uses_from_macos "curl" => :build
  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    # Replace man page "#version" and "#date" based on logic in release.sh
    inreplace "man/page" do |s|
      s.gsub! "#version", version
      s.gsub! "#date", time.strftime("%Y/%m/%d")
    end
    man1.install "man/page" => "broot.1"

    # Completion scripts are generated in the crate's build directory,
    # which includes a fingerprint hash. Try to locate it first
    out_dir = Dir["target/release/build/broot-*/out"].first
    bash_completion.install "#{out_dir}/broot.bash"
    bash_completion.install "#{out_dir}/br.bash"
    fish_completion.install "#{out_dir}/broot.fish"
    fish_completion.install "#{out_dir}/br.fish"
    zsh_completion.install "#{out_dir}/_broot"
    zsh_completion.install "#{out_dir}/_br"
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    output = shell_output("#{bin}/broot --help")
    assert_match "lets you explore file hierarchies with a tree-like view", output

    assert_match version.to_s, shell_output("#{bin}/broot --version")

    require "pty"
    require "io/console"
    PTY.spawn(bin/"broot", "-c", ":print_tree", "--color", "no", "--outcmd", testpath/"output.txt",
                err: :out) do |r, w, pid|
      r.winsize = [20, 80] # broot dependency terminal requires width > 2
      w.write "n\r"
      assert_match "New Configuration files written in", r.read
      Process.wait(pid)
    end
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
