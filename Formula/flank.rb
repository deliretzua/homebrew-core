class Flank < Formula
  desc "Massively parallel Android and iOS test runner for Firebase Test Lab"
  homepage "https://github.com/Flank/flank"
  url "https://github.com/Flank/flank/releases/download/v23.06.0/flank.jar"
  sha256 "f7d25407aabafc0af701a3d456f1580abeb42bb8e5692cd88afd02049cd3446c"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b7dc37f1865f70e6eb12ae132fdb8e142210217798ff43eb46dad35600bbeeb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b7dc37f1865f70e6eb12ae132fdb8e142210217798ff43eb46dad35600bbeeb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b7dc37f1865f70e6eb12ae132fdb8e142210217798ff43eb46dad35600bbeeb"
    sha256 cellar: :any_skip_relocation, ventura:        "3b7dc37f1865f70e6eb12ae132fdb8e142210217798ff43eb46dad35600bbeeb"
    sha256 cellar: :any_skip_relocation, monterey:       "3b7dc37f1865f70e6eb12ae132fdb8e142210217798ff43eb46dad35600bbeeb"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b7dc37f1865f70e6eb12ae132fdb8e142210217798ff43eb46dad35600bbeeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aaa8f8cfa815a13653d987f7fb22f70ced225b1c147e0fa6654e063b814beab6"
  end

  depends_on "openjdk"

  def install
    libexec.install "flank.jar"
    bin.write_jar_script libexec/"flank.jar", "flank"
  end

  test do
    (testpath/"flank.yml").write <<~EOS
      gcloud:
        device:
        - model: Pixel2
          version: "29"
          locale: en
          orientation: portrait
    EOS

    output = shell_output("#{bin}/flank android doctor")
    assert_match "Valid yml file", output
  end
end
