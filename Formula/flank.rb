class Flank < Formula
  desc "Massively parallel Android and iOS test runner for Firebase Test Lab"
  homepage "https://github.com/Flank/flank"
  url "https://github.com/Flank/flank/releases/download/v23.06.1/flank.jar"
  sha256 "c376ba3ddca7ad1f89b81aad1d03e065034ebde8dd03c8c37fee1c3dd8553f14"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae3211685f5a410140f89908ce7c623e5e46ee8d2bb9fa964459550e84f951b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae3211685f5a410140f89908ce7c623e5e46ee8d2bb9fa964459550e84f951b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae3211685f5a410140f89908ce7c623e5e46ee8d2bb9fa964459550e84f951b3"
    sha256 cellar: :any_skip_relocation, ventura:        "ae3211685f5a410140f89908ce7c623e5e46ee8d2bb9fa964459550e84f951b3"
    sha256 cellar: :any_skip_relocation, monterey:       "ae3211685f5a410140f89908ce7c623e5e46ee8d2bb9fa964459550e84f951b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae3211685f5a410140f89908ce7c623e5e46ee8d2bb9fa964459550e84f951b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a29213f3cbeab6886c9b143c2d26014705a167deb8cd67db9aa6708aed860bf5"
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
