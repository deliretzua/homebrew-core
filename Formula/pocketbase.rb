class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.16.3.tar.gz"
  sha256 "39c616f073772e041025c80398a261f76491d6370f1ac0cab1d61926d02b9809"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2af401425fb7241f206467cbb5d2ec5b55e15f50942048b2b19575718b6ca730"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2af401425fb7241f206467cbb5d2ec5b55e15f50942048b2b19575718b6ca730"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2af401425fb7241f206467cbb5d2ec5b55e15f50942048b2b19575718b6ca730"
    sha256 cellar: :any_skip_relocation, ventura:        "a642f8aff3e11e3e45afcb998e4fd6c494e14dde570aa030a7a2fb17f94d5753"
    sha256 cellar: :any_skip_relocation, monterey:       "a642f8aff3e11e3e45afcb998e4fd6c494e14dde570aa030a7a2fb17f94d5753"
    sha256 cellar: :any_skip_relocation, big_sur:        "a642f8aff3e11e3e45afcb998e4fd6c494e14dde570aa030a7a2fb17f94d5753"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cabc0049c35cd2baff9c6414598dec64100b308d50fb41eb333afef0446be576"
  end

  depends_on "go" => :build

  uses_from_macos "netcat" => :test

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/pocketbase/pocketbase.Version=#{version}"), "./examples/base"
  end

  test do
    assert_match "pocketbase version #{version}", shell_output("#{bin}/pocketbase --version")

    port = free_port
    _, _, pid = PTY.spawn("#{bin}/pocketbase serve --dir #{testpath}/pb_data --http 127.0.0.1:#{port}")
    sleep 5

    system "nc", "-z", "localhost", port
    Process.kill "SIGINT", pid

    assert_predicate testpath/"pb_data", :exist?, "pb_data directory should exist"
    assert_predicate testpath/"pb_data", :directory?, "pb_data should be a directory"

    assert_predicate testpath/"pb_data/data.db", :exist?, "pb_data/data.db should exist"
    assert_predicate testpath/"pb_data/data.db", :file?, "pb_data/data.db should be a file"

    assert_predicate testpath/"pb_data/logs.db", :exist?, "pb_data/logs.db should exist"
    assert_predicate testpath/"pb_data/logs.db", :file?, "pb_data/logs.db should be a file"
  end
end
