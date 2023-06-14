class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/v7.20.4.tar.gz"
  sha256 "b5c5f83c3e276d4a0c02fdc9704aafd1c297e3a8ef794fcf889fc94bd19b9df5"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fdba7b48c3560d759763e4c51043827aa3379d4b623465ac834629d53e4e19db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98065bec7978809cc4662df03cea14c8093ecc797d5a1ef0dee3abe7ab963c4b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "872926b6010873b480e0938f640ac0860f7c9ca77bc7d93f98e2a0f918e16fde"
    sha256 cellar: :any_skip_relocation, ventura:        "711fb88c8ff467052c84628a064c23c7d7c21dd1ae6c7f9c1ec6a866068ad13b"
    sha256 cellar: :any_skip_relocation, monterey:       "d199cd776ca884b1319819484645dd1fc88e85e5aff18c5a5f9001a7dc679bc4"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea72c307be17f8911ab1bf5a92428c5f9d3a2d3d491e9346fd15294761255663"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79c37120a081ed4bd0db267c11c77fc66746e8ee6456697313a36dc53d203523"
  end

  depends_on "go" => :build

  def install
    %w[rqbench rqlite rqlited].each do |cmd|
      system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bin/cmd, "./cmd/#{cmd}"
    end
  end

  test do
    port = free_port
    fork do
      exec bin/"rqlited", "-http-addr", "localhost:#{port}",
                          "-raft-addr", "localhost:#{free_port}",
                          testpath
    end
    sleep 5

    (testpath/"test.sql").write <<~EOS
      CREATE TABLE foo (id INTEGER NOT NULL PRIMARY KEY, name TEXT)
      .schema
      quit
    EOS
    output = shell_output("#{bin}/rqlite -p #{port} < test.sql")
    assert_match "foo", output

    output = shell_output("#{bin}/rqbench -a localhost:#{port} 'SELECT 1'")
    assert_match "Statements/sec", output
  end
end
