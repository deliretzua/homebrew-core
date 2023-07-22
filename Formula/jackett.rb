class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.510.tar.gz"
  sha256 "1abeafbda86547145515580add94521a141064cb0fdc698ae92560cd49d6391c"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f8e2d49ce34f169e64c5638fe64f921edeb27e093ab3b6555a1d73b9d646a31c"
    sha256 cellar: :any,                 arm64_monterey: "a423bfc2b0964fdf1f7b46071eb8efdb658d35affe13525d236961884e4c362c"
    sha256 cellar: :any,                 arm64_big_sur:  "4966a9701c996b811a0af5462789a64ca9216fbbcacc30bc0ef0d01b2c7c8338"
    sha256 cellar: :any,                 ventura:        "a6bcfe3525f87b40ae2df69410bd196285f5a4e41388a8a5e209c148a2a7b76f"
    sha256 cellar: :any,                 monterey:       "c1bb35833a4a1081df055621a005008c2f0f4bf21eb895de8c958dfea9741524"
    sha256 cellar: :any,                 big_sur:        "ed4a4866964487dcec38cdc10f8af0fc24dd31e2374be33140cf6615b1220771"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9bb493fe42066e131bd4310663c465cefeac3d72c1f16ba71901089d0fbb17c"
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
