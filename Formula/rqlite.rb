class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/v7.15.1.tar.gz"
  sha256 "846c166554fa3f940db7c26ccc2efe3a4c3ef97d6d821549a01e2b07a2bc77f2"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94b1f8d31a1c148f6d6b9f4aacbab9f53c4783ba596e10719d157a28bafd8d79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bba7cf6a952da4ba88aabc22e1f54345d3701a9bf68af123fc3abb1a68fdc70"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c7afaa6cfbc11f2df59eaf96d076208a656841fa38ffb1279f3bb7c05e0efca"
    sha256 cellar: :any_skip_relocation, ventura:        "2bfae55ac22b9a6ba9b02462ff5c5b7965fe5b2840c2fb31aad59690720a60ee"
    sha256 cellar: :any_skip_relocation, monterey:       "92f6f2db19c5e3b2c615aac1b80f55ab0d7c3f753deab3e1202fa57996a19662"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6f02cac33ac125b91fa0c04452047c6bad961cbb4f58386f055560a909d766e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5cb74f4840e2f5fa21646a7bac39a76dfd4af6f97493e33d45e85379429f1fa"
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
