class TrustDns < Formula
  desc "Rust based DNS client, server, and resolver"
  homepage "https://github.com/bluejekyll/trust-dns"
  url "https://github.com/bluejekyll/trust-dns/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "0756101c4ecd20ba5cfb3d0d1b86fe19bd28daae988004c153fe1c0a052bfb85"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/bluejekyll/trust-dns.git", branch: "main"

  depends_on "rust" => :build

  on_linux do
    depends_on "bind" => :test # for `dig`
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "bin")
    pkgshare.install "tests/test-data"
  end

  test do
    test_port = free_port
    cp_r pkgshare/"test-data", testpath
    test_config_path = testpath/"test-data/named_test_configs"
    example_config = test_config_path/"example.toml"

    pid = fork do
      exec bin/"trust-dns", "-c", example_config, "-z", test_config_path, "-p", test_port.to_s
    end
    sleep 2
    output = shell_output("dig @127.0.0.1 -p #{test_port} www.example.com")
    expected = "www.example.com.	86400	IN	A	127.0.0.1"
    assert_match expected, output

    assert_match "trust-dns #{version}", shell_output("#{bin}/trust-dns --version")
  ensure
    Process.kill "SIGTERM", pid
    Process.wait pid
  end
end
