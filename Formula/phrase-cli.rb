class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.8.2.tar.gz"
  sha256 "e1b479ba88a08595630904de5e9bbed9154b61fa449359d61f41e50f5c512a43"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fdefb98ecc3278a57aac442a3f2423b43c5919b0bf2d01e9bf8d57cbe5c42dd7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fdefb98ecc3278a57aac442a3f2423b43c5919b0bf2d01e9bf8d57cbe5c42dd7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fdefb98ecc3278a57aac442a3f2423b43c5919b0bf2d01e9bf8d57cbe5c42dd7"
    sha256 cellar: :any_skip_relocation, ventura:        "ac06971b962c8817e257c2b276b1e16616695f559e73961f1a97da00679038d9"
    sha256 cellar: :any_skip_relocation, monterey:       "ac06971b962c8817e257c2b276b1e16616695f559e73961f1a97da00679038d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac06971b962c8817e257c2b276b1e16616695f559e73961f1a97da00679038d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3a135580ba1e06ee7bca26c9e463df1bae4e9b8ca778da375702a08af4a1a3e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s
      -w
      -X=github.com/phrase/phrase-cli/cmd.PHRASE_CLIENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    bin.install_symlink "phrase-cli" => "phrase"

    generate_completions_from_executable(bin/"phrase", "completion", base_name: "phrase", shells: [:bash])
  end

  test do
    assert_match "ERROR: no targets for download specified", shell_output("#{bin}/phrase pull 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/phrase version")
  end
end
