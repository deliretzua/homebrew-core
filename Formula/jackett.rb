class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3814.tar.gz"
  sha256 "950a28795af9200dea0dfe33de8ec414867083e3fed4c3e8dba771b832bcd7b5"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2b8fe1524c5b5eb4d7e295f0ff85fc6434cf6a0009fee2c3576f77ddf8cb2ef3"
    sha256 cellar: :any,                 arm64_monterey: "cf4aa83eb9d6af275cd24a76faa9e0f9df1cf582b7ee456d023f61c2e0f9588f"
    sha256 cellar: :any,                 arm64_big_sur:  "e472a0943ba381ecac0b460a4e78c12125f81a53fbc9d25223bf1d102a27cb4a"
    sha256 cellar: :any,                 ventura:        "43daca9c25ed45a4a34563f5ef06ca3556001a1b1f82197b420afab3f0757138"
    sha256 cellar: :any,                 monterey:       "e4e8e5739515ac4848e8d20168397de13fe8e84586908da63b6f16513fbc52d3"
    sha256 cellar: :any,                 big_sur:        "d3c1c81e7ac24056bfb43085e7f0bf4faeb61ed14a630e55eaa23cf6a255fae7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa026f4834a19eceb64304d1c48f0d203ba0766ea42a801bba71cc2f5b74e000"
  end

  depends_on "dotnet@6"

  def install
    dotnet = Formula["dotnet@6"]
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
    ]
    if build.stable?
      args += %W[
        /p:AssemblyVersion=#{version}
        /p:FileVersion=#{version}
        /p:InformationalVersion=#{version}
        /p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "src/Jackett.Server", *args

    (bin/"jackett").write_env_script libexec/"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin/"jackett"
    keep_alive true
    working_dir libexec
    log_path var/"log/jackett.log"
    error_log_path var/"log/jackett.log"
  end

  test do
    assert_match(/^Jackett v#{Regexp.escape(version)}$/, shell_output("#{bin}/jackett --version 2>&1; true"))

    port = free_port

    pid = fork do
      exec "#{bin}/jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 10
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
