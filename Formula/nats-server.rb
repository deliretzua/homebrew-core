class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/v2.9.17.tar.gz"
  sha256 "9e2042f988900c68ac987c3295220bb981884dff30276e69294f8d95463a54e8"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "556303545316851b085607d8e1d886785bc88caf985b6b6852bbd7b538480876"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "556303545316851b085607d8e1d886785bc88caf985b6b6852bbd7b538480876"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "556303545316851b085607d8e1d886785bc88caf985b6b6852bbd7b538480876"
    sha256 cellar: :any_skip_relocation, ventura:        "4455432bd3f4a564cfc0f449b4cf97854084a5313bd3546279e64bd6d8804cbe"
    sha256 cellar: :any_skip_relocation, monterey:       "4455432bd3f4a564cfc0f449b4cf97854084a5313bd3546279e64bd6d8804cbe"
    sha256 cellar: :any_skip_relocation, big_sur:        "4455432bd3f4a564cfc0f449b4cf97854084a5313bd3546279e64bd6d8804cbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc027397beb0ceb88154f7568ebac044b081b4b4d06f7d21127882ec14a5fa83"
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
