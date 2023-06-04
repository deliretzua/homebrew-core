class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/v5.7.0.tar.gz"
  sha256 "599fcd264537e39178b6008a11af68816dfd1609e19a9cf8adc8b2a4240ee370"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0b78394cb7d43981afa964bbb320788a98323e7fc5ba07d1cd859ffed1580a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0b78394cb7d43981afa964bbb320788a98323e7fc5ba07d1cd859ffed1580a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0b78394cb7d43981afa964bbb320788a98323e7fc5ba07d1cd859ffed1580a7"
    sha256 cellar: :any_skip_relocation, ventura:        "00932a6b62ee02099be5009e97d3d1f1e97de78935023c83bdd749b179884854"
    sha256 cellar: :any_skip_relocation, monterey:       "00932a6b62ee02099be5009e97d3d1f1e97de78935023c83bdd749b179884854"
    sha256 cellar: :any_skip_relocation, big_sur:        "00932a6b62ee02099be5009e97d3d1f1e97de78935023c83bdd749b179884854"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4234ad1e6a9c9eb46f14e4b7b7b323014fcc11343665a73be6f3e4e2a9fc1f83"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202306010100/geoip.dat"
    sha256 "033864e77e40f8b9c1a5254bf85881515c51340d3d11e142a4e01594eb151914"
  end

  resource "geoip-only-cn-private" do
    url "https://github.com/v2fly/geoip/releases/download/202306010100/geoip-only-cn-private.dat"
    sha256 "28b90fe51eba6af7c19a637a4f5ce91157b7efff54c8a702a57642da9c196e30"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20230601044045/dlc.dat"
    sha256 "d20bcd23c185dd3102a2106ad5370bc615cfb33d9a818daaadefe7a2068fb9ef"
  end

  def install
    ldflags = "-s -w -buildid="
    system "go", "build", *std_go_args(ldflags: ldflags, output: libexec/"v2ray"), "./main"

    (bin/"v2ray").write_env_script libexec/"v2ray",
      V2RAY_LOCATION_ASSET: "${V2RAY_LOCATION_ASSET:-#{pkgshare}}"

    pkgetc.install "release/config/config.json"

    resource("geoip").stage do
      pkgshare.install "geoip.dat"
    end

    resource("geoip-only-cn-private").stage do
      pkgshare.install "geoip-only-cn-private.dat"
    end

    resource("geosite").stage do
      pkgshare.install "dlc.dat" => "geosite.dat"
    end
  end

  service do
    run [opt_bin/"v2ray", "run", "-config", etc/"v2ray/config.json"]
    keep_alive true
  end

  test do
    (testpath/"config.json").write <<~EOS
      {
        "log": {
          "access": "#{testpath}/log"
        },
        "outbounds": [
          {
            "protocol": "freedom",
            "tag": "direct"
          }
        ],
        "routing": {
          "rules": [
            {
              "ip": [
                "geoip:private"
              ],
              "outboundTag": "direct",
              "type": "field"
            },
            {
              "domains": [
                "geosite:private"
              ],
              "outboundTag": "direct",
              "type": "field"
            }
          ]
        }
      }
    EOS
    output = shell_output "#{bin}/v2ray test -c #{testpath}/config.json"

    assert_match "Configuration OK", output
    assert_predicate testpath/"log", :exist?
  end
end
