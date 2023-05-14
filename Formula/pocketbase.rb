class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "abc524d9a4e9235e6b2d9d274df1a9fd987f17d42427f3b085f777c064a29fd9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ba7fda122847e24fe667092030cfb835141b79d1e00cd3ce03f0043702f50c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ba7fda122847e24fe667092030cfb835141b79d1e00cd3ce03f0043702f50c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ba7fda122847e24fe667092030cfb835141b79d1e00cd3ce03f0043702f50c6"
    sha256 cellar: :any_skip_relocation, ventura:        "cb537aaa2a40a00586e03f4822c94d76c56d182317c4e22c2806951a1a4cea25"
    sha256 cellar: :any_skip_relocation, monterey:       "cb537aaa2a40a00586e03f4822c94d76c56d182317c4e22c2806951a1a4cea25"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb537aaa2a40a00586e03f4822c94d76c56d182317c4e22c2806951a1a4cea25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19a5dea9256ee7d8a1a94f045d7ab3dabbc3f26f698ce5d8c7de069bc09c3df0"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/pocketbase/pocketbase.Version=#{version}"), "./examples/base"
  end

  test do
    assert_match "pocketbase version #{version}", shell_output("#{bin}/pocketbase --version")

    system "#{bin}/pocketbase", "--dir", testpath/"pb_data"

    assert_predicate testpath/"pb_data", :exist?, "pb_data directory should exist"
    assert_predicate testpath/"pb_data", :directory?, "pb_data should be a directory"

    assert_predicate testpath/"pb_data/data.db", :exist?, "pb_data/data.db should exist"
    assert_predicate testpath/"pb_data/data.db", :file?, "pb_data/data.db should be a file"

    assert_predicate testpath/"pb_data/logs.db", :exist?, "pb_data/logs.db should exist"
    assert_predicate testpath/"pb_data/logs.db", :file?, "pb_data/logs.db should be a file"
  end
end
