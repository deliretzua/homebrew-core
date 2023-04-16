class MistCli < Formula
  desc "Mac command-line tool that automatically downloads macOS Firmwares / Installers"
  homepage "https://github.com/ninxsoft/mist-cli"
  url "https://github.com/ninxsoft/mist-cli/archive/refs/tags/v1.11.tar.gz"
  sha256 "f280e8ce2e40d78eec5525b2c1cbd8e399815d7f61ec5ce01dcd6baa642b9b8c"
  license "MIT"
  head "https://github.com/ninxsoft/mist-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2bb107b9296ff961c6397d425783c20f4203cf9eab2925dfb9de4291ee304ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36341b7ec3eb7e8e7e450c3050932255060e2558aaa098d72196de04f874c270"
    sha256 cellar: :any_skip_relocation, ventura:        "53e4fd9e88e5b171e3a50f417164d2343a852e34437508fbb36875e14ae3a60d"
    sha256 cellar: :any_skip_relocation, monterey:       "59dbaea07bd73bd259009939e94f362bcce79c21286576aac533b179e89a027f"
  end

  # mist-cli requires Swift 5.8
  depends_on xcode: ["14.3", :build]
  depends_on :macos
  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/mist"
  end

  test do
    # basic usage output
    assert_match "-h, --help", shell_output("#{bin}/mist").strip

    # check we can export the output list
    out = testpath/"out.json"
    system bin/"mist", "list", "firmware", "--quiet", "--export=#{out}", "--output-type=json"
    assert_predicate out, :exist?

    # check that it's parseable JSON in the format we expect
    parsed = JSON.parse(File.read(out))
    assert_kind_of Array, parsed
  end
end
