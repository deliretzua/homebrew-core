class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.121.38.tar.gz"
  sha256 "857020ffe1a6e0adc16233c01d73fd4ecc70866ce37f5412fcd432300749a949"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "354a8022564b3da9075feac424a21c9327c9db54b4638e737dd740d5ed86ccac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b558133112e72341a2f92cc69e9da1d9ec9024e3a6636d42de99aaca0c9f0b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "573dd2956ec3b55b316e47ff3abaae86433dc3f66b18a5354336033a4e6fda67"
    sha256 cellar: :any_skip_relocation, ventura:        "dfd92187956760be45e683e1b99c5ed34cf60e6c427c516f965a9ece42841deb"
    sha256 cellar: :any_skip_relocation, monterey:       "67b3a0fe8ce89cd6f899236e4ad46b886d0dbe6512e8580d016fb0050b987fb2"
    sha256 cellar: :any_skip_relocation, big_sur:        "149ddff058a1a4e8a75ca9bc48788f8a1b033394dcba987487a598d4f30884e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6504eb9998f7cd6054178698977b4d83c836882030426fa3626c41078e0cee6f"
  end

  depends_on "go" => :build

  # patch the version override, remove in next release
  patch do
    url "https://github.com/vespa-engine/vespa/commit/121cc99584a9d99950c4037162c43b5f583a312d.patch?full_index=1"
    sha256 "7002a836d8424dccc593435b9c8bb97f95d6cc8f78a4938f2f91ac5da8ed2c89"
  end

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "all", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", "completion")
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
