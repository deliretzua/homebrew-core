class VirustotalCli < Formula
  desc "Command-line interface for VirusTotal"
  homepage "https://github.com/VirusTotal/vt-cli"
  url "https://github.com/VirusTotal/vt-cli/archive/0.14.0.tar.gz"
  sha256 "48b05532c8f3e02cf241a013a3e5a7747e9e882018e17fbf40c6a6b46af00fa8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5d8f4189c1f55fef87804cf4e0917b1a21377433839392087d8f3203099f6b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5d8f4189c1f55fef87804cf4e0917b1a21377433839392087d8f3203099f6b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5d8f4189c1f55fef87804cf4e0917b1a21377433839392087d8f3203099f6b0"
    sha256 cellar: :any_skip_relocation, ventura:        "81dbf51586a117b2e8e96a9a8ad541f1062b80c51a1316fbea8e02dff9597bb4"
    sha256 cellar: :any_skip_relocation, monterey:       "81dbf51586a117b2e8e96a9a8ad541f1062b80c51a1316fbea8e02dff9597bb4"
    sha256 cellar: :any_skip_relocation, big_sur:        "81dbf51586a117b2e8e96a9a8ad541f1062b80c51a1316fbea8e02dff9597bb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "210262b89aa36e224a9e1d328d693dde4dc5bec87c89cd601be53f8635a0b409"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"vt", ldflags: "-X cmd.Version=#{version}"), "./vt/main.go"

    generate_completions_from_executable(bin/"vt", "completion", base_name: "vt")
  end

  test do
    output = shell_output("#{bin}/vt url #{homepage} 2>&1", 1)
    assert_match "Error: An API key is needed", output
  end
end
