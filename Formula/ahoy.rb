class Ahoy < Formula
  desc "Creates self documenting CLI programs from commands in YAML files"
  homepage "https://ahoy-cli.readthedocs.io/"
  url "https://github.com/ahoy-cli/ahoy/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "38189a92e39e3ae3a34be491dd2cd010928debe46b112ad82336fafa852556b9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c96cbeaccf5a79de7220ee10c49604a73ae9eb0aefe690c4d8b71d040ce4b39b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c96cbeaccf5a79de7220ee10c49604a73ae9eb0aefe690c4d8b71d040ce4b39b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c96cbeaccf5a79de7220ee10c49604a73ae9eb0aefe690c4d8b71d040ce4b39b"
    sha256 cellar: :any_skip_relocation, ventura:        "92ba3fbb7bf1b3948a9f8a4493ad3d0cda2255ec69b882e4ebf19c60f2bc2238"
    sha256 cellar: :any_skip_relocation, monterey:       "92ba3fbb7bf1b3948a9f8a4493ad3d0cda2255ec69b882e4ebf19c60f2bc2238"
    sha256 cellar: :any_skip_relocation, big_sur:        "92ba3fbb7bf1b3948a9f8a4493ad3d0cda2255ec69b882e4ebf19c60f2bc2238"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8591033979f7f12578775befdab7d3ae0b9996ac381b17901df58a57755a9fc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}-homebrew")
  end

  def caveats
    <<~EOS
      ===== UPGRADING FROM 1.x TO 2.x =====

      If you are upgrading from ahoy 1.x, note that you'll
      need to upgrade your ahoyapi settings in your .ahoy.yml
      files to 'v2' instead of 'v1'.

      See other changes at:

      https://github.com/ahoy-cli/ahoy

    EOS
  end

  test do
    (testpath/".ahoy.yml").write <<~EOS
      ahoyapi: v2
      commands:
        hello:
          cmd: echo "Hello Homebrew!"
    EOS
    assert_equal "Hello Homebrew!\n", `#{bin}/ahoy hello`

    assert_equal "#{version}-homebrew", shell_output("#{bin}/ahoy --version").strip
  end
end
