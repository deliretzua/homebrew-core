class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.16.10.tar.gz"
  sha256 "3b5b4789119a6e1cbc12a3044a4b1a752172604bf4737de1fb33bba1c0726f1e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83ce452bf2b606b2a4189579c3e13017dab614a1f280169a7da226307a17b0e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83ce452bf2b606b2a4189579c3e13017dab614a1f280169a7da226307a17b0e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83ce452bf2b606b2a4189579c3e13017dab614a1f280169a7da226307a17b0e5"
    sha256 cellar: :any_skip_relocation, ventura:        "0f29b3848aa55565d0151753e1818970286a2107626575233ec63fdb8bcd6cc7"
    sha256 cellar: :any_skip_relocation, monterey:       "0f29b3848aa55565d0151753e1818970286a2107626575233ec63fdb8bcd6cc7"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f29b3848aa55565d0151753e1818970286a2107626575233ec63fdb8bcd6cc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d18e692a6da5784fecb0ee9cda1da29e81fbd008a73dba09d49de7007d77957"
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
