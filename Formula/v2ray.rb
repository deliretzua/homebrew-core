class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/v5.4.1.tar.gz"
  sha256 "e208bca255c4689a30104e965039d73fa138a7a6e902f820cff94b5b772b042b"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5723257846b8654cb16145a612205c84187473bc5f9b1262cf225033dc37e6c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10da6c09888d253ceff55cde6b47be0a410cb2ebf45682aeda1a550a818158ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7849330a49cba7101751257828b314ed98c5284876ce30e8bdfb779b682f325"
    sha256 cellar: :any_skip_relocation, ventura:        "6b9d9ac0c64a0bc3d9dbf69704a3c3451c77d72b5055f0acea1c41056bc10bcc"
    sha256 cellar: :any_skip_relocation, monterey:       "6126e3149f5ad5ec1740d93ec4abc3fdc12e4d25fbbcc4847c2ad5062d2492a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "10faa7a439baabf978dffb73792a919b1e9ddfb547af9722943c0c4010b97d4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cf7dc9149a7e9f55e9ae405820df312ecf893e9a379c2e0a6d7c5ad1919c709"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202304130041/geoip.dat"
    sha256 "1bb3d15876748dbf0eaebb54261c8f00d24af0d53412a023577a74bfc3ce2607"
  end

  resource "geoip-only-cn-private" do
    url "https://github.com/v2fly/geoip/releases/download/202304130041/geoip-only-cn-private.dat"
    sha256 "d0571c83b4db0f4e05db20102c4dbfd2d9f5fbe0eafb6449c1ccaa820946dfe5"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20230415131855/dlc.dat"
    sha256 "f8560053112ae8fb5c72239ccb97d912bab21223b2c3a2bf698af3bbc7db146b"
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
