class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/v2.9.19.tar.gz"
  sha256 "541f77bcc5c71ccb267883e3080e60602ec57a02d9316557346af9bfe4f4193a"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b626d4d7676b6996fe9ef2fa0c24806d3cb4cf63b9a10677316d7d4205d3f8d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b626d4d7676b6996fe9ef2fa0c24806d3cb4cf63b9a10677316d7d4205d3f8d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b626d4d7676b6996fe9ef2fa0c24806d3cb4cf63b9a10677316d7d4205d3f8d1"
    sha256 cellar: :any_skip_relocation, ventura:        "721a04ea8fc05278b67e45735b1e983764583f8df43f32bf69ce188d4290205a"
    sha256 cellar: :any_skip_relocation, monterey:       "721a04ea8fc05278b67e45735b1e983764583f8df43f32bf69ce188d4290205a"
    sha256 cellar: :any_skip_relocation, big_sur:        "721a04ea8fc05278b67e45735b1e983764583f8df43f32bf69ce188d4290205a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32969367e251457924cccd84b961dc5c33b4436d9e442ed36e455e1a776d4754"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  service do
    run opt_bin/"nats-server"
  end

  test do
    port = free_port
    http_port = free_port
    fork do
      exec bin/"nats-server",
           "--port=#{port}",
           "--http_port=#{http_port}",
           "--pid=#{testpath}/pid",
           "--log=#{testpath}/log"
    end
    sleep 3

    assert_match version.to_s, shell_output("curl localhost:#{http_port}/varz")
    assert_predicate testpath/"log", :exist?
  end
end
