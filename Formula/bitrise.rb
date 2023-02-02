class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/2.2.3.tar.gz"
  sha256 "4db2d83f68373b1792c2e0b5f2837704dd0c50886e6b9d0bd7eda09922311384"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e012ecf70113f1a553e605d36587f20d229541123add27a38457e25d2330e97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80162e7212090d232e897bd0f1f2cc58aae37b233fc6bdf436643089ebfd3bac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6edb702b2c310237d61ec078338cb8040ed1d1421d3be9594382fd4ca997c24"
    sha256 cellar: :any_skip_relocation, ventura:        "7043fe332dc5c70a8f0bda13a6b8f357391ee9c179374504c2f15c73d67cc7c6"
    sha256 cellar: :any_skip_relocation, monterey:       "5c491894dccc5225e5b46ed9a873731634d3f11dd7e0ac2e190dae20747630b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "80ed150ae782d157973ece70a20df6ee436119978fc4d7412d0d742012ec63dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7851ef5b5e6d1fe0535646f680fa78c2d877c06ef6e2525c58406f0a18210b9e"
  end

  depends_on "go" => :build

  uses_from_macos "rsync"

  def install
    ldflags = %W[
      -s -w
      -X github.com/bitrise-io/bitrise/version.VERSION=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags.join(" "))
  end

  test do
    (testpath/"bitrise.yml").write <<~EOS
      format_version: 1.3.1
      default_step_lib_source: https://github.com/bitrise-io/bitrise-steplib.git
      workflows:
        test_wf:
          steps:
          - script:
              inputs:
              - content: printf 'Test - OK' > brew.test.file
    EOS

    system "#{bin}/bitrise", "setup"
    system "#{bin}/bitrise", "run", "test_wf"
    assert_equal "Test - OK", (testpath/"brew.test.file").read.chomp
  end
end
