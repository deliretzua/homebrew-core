class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.30.6.tar.gz"
  sha256 "5f1691f5a1832058bbb12d8535d259a99daf73671b92e272ac1ec69bda6df295"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "badd873fef66453e1921d7ca29218cabd9340dc05ef5624a1f9599cc0984359d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fff40f607de998d3dc10acf625d6dbef4d379faa9e49d60c06a1dc4f77f2cf14"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e38dda026fd3d61d58789591d1a0f7158ee1362ab81e7111f4684f4396d42460"
    sha256 cellar: :any_skip_relocation, ventura:        "4ae1a7123a7cf21cab1f619221d53cc91f92940c48290e3a8bdff7b31c6d91e7"
    sha256 cellar: :any_skip_relocation, monterey:       "ade4be29effc49e4b14e0ef83836ca99b4163c256f921f6e330420550efa76e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "b43266ebb050b12d61d108f43271e2cae7b3650b8395dd5b5e4f2fc68b14112c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a73cff06fb6f632c10a8434f9e6bfc8cafbc9b6ead1243466134724fd965dc2d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
