class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v5.25.0.tar.gz"
  sha256 "83fe876d953b4f2f7a856552e758aae4aa0cd9569dcf1aded61bdc834b834275"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9721f1222d207b6c10641323b64fb5f05f6177c7db161e0dc8ad2cdc4e5efce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9721f1222d207b6c10641323b64fb5f05f6177c7db161e0dc8ad2cdc4e5efce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9721f1222d207b6c10641323b64fb5f05f6177c7db161e0dc8ad2cdc4e5efce"
    sha256 cellar: :any_skip_relocation, ventura:        "212c209350ab233d1bb6edb37b10df7a45ebaab214e44434e7343c8fbdc02ffb"
    sha256 cellar: :any_skip_relocation, monterey:       "212c209350ab233d1bb6edb37b10df7a45ebaab214e44434e7343c8fbdc02ffb"
    sha256 cellar: :any_skip_relocation, big_sur:        "212c209350ab233d1bb6edb37b10df7a45ebaab214e44434e7343c8fbdc02ffb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a58b3dad1cc6ec6e264ce3f66efcae4f76a96641621368d0195f8673aba42328"
  end

  depends_on "go" => :build

  conflicts_with "coreutils", because: "both install `gdu` binaries"

  def install
    user = Utils.safe_popen_read("id", "-u", "-n")
    major = version.major

    ldflags = %W[
      -s -w
      -X "github.com/dundee/gdu/v#{major}/build.Version=v#{version}"
      -X "github.com/dundee/gdu/v#{major}/build.Time=#{time}"
      -X "github.com/dundee/gdu/v#{major}/build.User=#{user}"
    ]

    system "go", "build", *std_go_args(ldflags: ldflags, output: "#{bin}/gdu-go"), "./cmd/gdu"
  end

  def caveats
    <<~EOS
      To avoid a conflict with `coreutils`, `gdu` has been installed as `gdu-go`.
    EOS
  end

  test do
    mkdir_p testpath/"test_dir"
    (testpath/"test_dir"/"file1").write "hello"
    (testpath/"test_dir"/"file2").write "brew"

    assert_match version.to_s, shell_output("#{bin}/gdu-go -v")
    assert_match "colorized", shell_output("#{bin}/gdu-go --help 2>&1")
    output = shell_output("#{bin}/gdu-go --non-interactive --no-progress #{testpath}/test_dir 2>&1")
    assert_match "4.0 KiB file1", output
  end
end
