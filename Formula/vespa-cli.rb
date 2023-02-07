class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.120.11.tar.gz"
  sha256 "a3c3c275ad19670fa54bb7a06babe3528994976a306f636af511437ae4b45b2b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "864814d474e1da36dc889cdd410a56270b568389d29a38cb1c1a1f0a2210a40d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97328acf6d62cccf99a74f33dd84b3f41c158ca1253f9e407166073a5d297dcd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ca5b7dccc4b81ea52a952d8841eee7ec388cd8efdece58d9eaf2493e97aa1bd"
    sha256 cellar: :any_skip_relocation, ventura:        "9aa2b6474963888c101f88758acdc8a7f0434a18bba3d2d6b09a55d1b3118b17"
    sha256 cellar: :any_skip_relocation, monterey:       "020cdc786fd4b3b05ffbdccbb949b39bb7b171766ce82b5f9dbdc2777ab11c76"
    sha256 cellar: :any_skip_relocation, big_sur:        "94fb27f520eaf43af8db703a50984e2c494e512e5ac485f23e79aa66e9d6c046"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c22a3bc45ba6d4d7a657986fa35cf0c850403483891ff8b6a51cbf9f209208ec"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s) do
        system "make", "all", "manpages"
      end
      bin.install "bin/vespa"
      man1.install Dir["share/man/man1/vespa*.1"]
      generate_completions_from_executable(bin/"vespa", "completion", base_name: "vespa")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    assert_match "Error: Request failed", shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
