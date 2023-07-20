class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/stateful/runme.git",
      tag:      "v1.5.2",
      revision: "dfe6bdf5f83595ecd3754d8a3178223451108c1f"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c4a33baf8bd4a440774095ffbd2a95112c233b96c2e11ed77f28765d9c4c757"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e52891d28a7bb3bbdfa7f71329e45848b645faf7998d358e117acf66d1bf4c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66b2405708d0b79113817375e92e054c27c890af30e76e361004880c4d6d85e1"
    sha256 cellar: :any_skip_relocation, ventura:        "1059a83a8e333b0107cc8bfec5485ea38cd6867709ee9c8ba7ea25f1e400c113"
    sha256 cellar: :any_skip_relocation, monterey:       "385d47ecffa0e47e63fef0fae7138b28de3c278b16ff542200c748ee74537974"
    sha256 cellar: :any_skip_relocation, big_sur:        "440d575d5d13fce21b0fa738f921703cf4b24e5699d4cc892a8fe670a027c78d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87b659eef5191f1b95a7bd798844d2e6e1ea6892e74a4eeaa7041d9c134af5c6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stateful/runme/internal/version.BuildDate=#{time.iso8601}
      -X github.com/stateful/runme/internal/version.BuildVersion=#{version}
      -X github.com/stateful/runme/internal/version.Commit=#{Utils.git_head}
    ]

    system "go", "build", "-o", bin, *std_go_args(ldflags: ldflags), "./main.go"
    generate_completions_from_executable(bin/"runme", "completion", shells: [:bash, :zsh, :fish])
  end

  test do
    system "#{bin}/runme", "--version"
    markdown = (testpath/"README.md")
    markdown.write <<~EOS
      # Some Markdown

      Has some text.

      ```sh { name=foobar }
      echo "Hello World"
      ```
    EOS
    assert_match "Hello World", shell_output("#{bin}/runme run foobar")
    assert_match "foobar", shell_output("#{bin}/runme list")
  end
end
