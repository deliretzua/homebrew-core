class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.56.1.tar.gz"
  sha256 "15e32033778a010b90aad58cb214bc65fde6e6eff7a7c9a19710549f18799e4c"
  license "MIT"
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "89eb8d401402d720e8888c20640531d7dae8f9c5b2658625403aeef3942332f8"
    sha256 cellar: :any_skip_relocation, big_sur:       "710d843d79f9844ce3e0a8dbcc0ddbb78143ab540b2dd03ba96464f284d91c59"
    sha256 cellar: :any_skip_relocation, catalina:      "d6e2b104c9d37b1647d3541f73aa17527a7ef7934eaed88870c696aff33e7ab5"
    sha256 cellar: :any_skip_relocation, mojave:        "6107ae59c714104be5c1574f6b42ca40ec6ea6cab4a00d84ef3979c139c4c4de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62291ba65c0dba5c2f8c85fb3b9b461099ccf8c4d800b133373e509d21f0f40b"
  end

  depends_on "go" => :build

  # Fix build on go 1.17, remove with next release
  patch do
    url "https://github.com/rclone/rclone/commit/8bd26c663ab19eaded9769a73dcb956f653276f6.patch?full_index=1"
    sha256 "59e2af681c8ce6c7b6cb4b673447ff49e5b244411b23fb15f5fbfc0cb6b2fe8d"
  end

  def install
    args = *std_go_args(ldflags: "-s -w -X github.com/rclone/rclone/fs.Version=v#{version}")
    args += ["-tags", "brew"] if OS.mac?
    system "go", "build", *args
    man1.install "rclone.1"
    system bin/"rclone", "genautocomplete", "bash", "rclone.bash"
    system bin/"rclone", "genautocomplete", "zsh", "_rclone"
    bash_completion.install "rclone.bash" => "rclone"
    zsh_completion.install "_rclone"
  end

  def caveats
    <<~EOS
      Homebrew's installation does not include the `mount` subcommand on MacOS.
    EOS
  end

  test do
    (testpath/"file1.txt").write "Test!"
    system bin/"rclone", "copy", testpath/"file1.txt", testpath/"dist"
    assert_match File.read(testpath/"file1.txt"), File.read(testpath/"dist/file1.txt")
  end
end
