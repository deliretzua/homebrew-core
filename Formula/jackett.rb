class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3105.tar.gz"
  sha256 "d3b7984bad5ed35d1287d4d72a39fda5a95075d98638e220f009837d5b243572"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d9f3990b12a5d349d9fd529dbddbaa2c8db641fd622918c0841267f8857dddd0"
    sha256 cellar: :any,                 arm64_monterey: "dc8bf3119202093e51df07efe2ea1aa6f722c40223dbcde4cbd1bf1c1d942941"
    sha256 cellar: :any,                 arm64_big_sur:  "fddba4db930e6e74bbe934c03b833d32624211283833ee2a66131a8da92e41ad"
    sha256 cellar: :any,                 ventura:        "74ace183a217f63bb7266c134dc660bbd65198096fc9772f847057e05d6385a9"
    sha256 cellar: :any,                 monterey:       "a304701f4cd98cc95100f2acb37807357429f45b2eed5ff6b00ee475bc94f7ec"
    sha256 cellar: :any,                 big_sur:        "040878679629bcf98a4b4c86abf47a490419b8e776f426d3083fbb78aa447ffb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "130d98972b2adb099f1e4748f4dbee9c6cb33cac128f541a97e25cc9814a0309"
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
