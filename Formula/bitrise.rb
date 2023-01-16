class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/2.2.1.tar.gz"
  sha256 "626a5caefc4fa8d51c8e70e75c051122e6627ebf7a7ac569f02520fecea0e470"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "602a3ea54b0471560ec69396688ff2a23cb5f05ec57f70f97114daf80d3d9b29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91501167a9d3d1025a426db086a4d8cd9b0636a5c32d28682bcfbff708d68897"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a804c2b31f40e53cf890b7d2dced6be536cfbffff108dac6cc6be326eadc93a4"
    sha256 cellar: :any_skip_relocation, ventura:        "23fa7933dd94f2ca7ca6daeac8d918a35cf8d96e75996ddf84d9040f5f063614"
    sha256 cellar: :any_skip_relocation, monterey:       "1f1ed63131c8df486f71b59092fe9bb5f73d81fba59e67d4c9967eea2c77197e"
    sha256 cellar: :any_skip_relocation, big_sur:        "43452da27f63d6c737b81dca2b73d79ecc0df1b591cdced71591bc54ac226d49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17c33e8940b4805048860817a213e59aae692c699cc05cc2d0bc70f91fc4aedb"
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
