class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.204.tar.gz"
  sha256 "65ebe38863cafc15ec8a7f34f1abc29995734d242fb62506550950f8eeb9b6d3"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b5852349422734c8f38bf1c028712c42228431777024478fb8374b132aaeeb3f"
    sha256 cellar: :any,                 arm64_monterey: "7b9eefca7dee5669bbc2931500ae0e5b0e11e36d2d3b294190a133df4cd0c49a"
    sha256 cellar: :any,                 arm64_big_sur:  "1a0e6afe23de17e7efba73364f0d85aeb6eaa965815d601f19cf6c4602dade58"
    sha256 cellar: :any,                 ventura:        "4d2313226a1d71626025fcf2c12f21963630ec2e744c699ce358723aa28029fc"
    sha256 cellar: :any,                 monterey:       "271a3742a7cff41e0f504909222ffc7a10c0dc5ad57def41c5e9596e77d2c0d1"
    sha256 cellar: :any,                 big_sur:        "21d78da7998416397802c9b870c69e0c0332551753fa205af675d2c9292b058d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89ba5fbf041fb66689248c5a699799ef8da521a3e0e454fd88dbeabe310b0990"
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
    working_dir opt_libexec
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
