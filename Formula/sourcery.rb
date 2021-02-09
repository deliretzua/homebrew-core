class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/1.1.1.tar.gz"
  sha256 "19a2c397b34e59b0fd4a0aa2ee156f39a3367991bd6b36c2723530b3d7db974e"
  license "MIT"
  head "https://github.com/krzysztofzablocki/Sourcery.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4ecd800da10736b64af20c2349af45f7bf3f02b6a04ad66451b64dea39ce3ece"
    sha256 cellar: :any_skip_relocation, big_sur:       "2dc8d382419ed945345bf1cd438798efbfe034390e79f909565d6e528f71f934"
    sha256 cellar: :any_skip_relocation, catalina:      "d0e76778b9bd1386d55104e94d4b7ff17790fcd75e3366804224c3ae9902f9e2"
  end

  depends_on xcode: "12.0"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/sourcery"
  end

  test do
    # Regular functionality requires a non-sandboxed environment, so we can only test version/help here.
    assert_match version.to_s, shell_output("#{bin}/sourcery --version").chomp
  end
end
