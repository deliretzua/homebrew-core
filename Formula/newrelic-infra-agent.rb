class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.42.2",
      revision: "07ab68f181e25a1552588a3953167e0b15f52372"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e8e48ddd8cf42634df00699ce9b2d3b7ec6d5b41f38639e5021d578b426e3da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cf3933580455f2e011785031f497ba3214bb07315b7dbec3fca33392b75da17"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1765990629b4f1b9bdcd90b221ebdf36a05decef927221fbce701aaac85927ce"
    sha256 cellar: :any_skip_relocation, ventura:        "b22ebd8f507b4a25025ecf7785feab859689338725ef35bd628f507bbecb200f"
    sha256 cellar: :any_skip_relocation, monterey:       "4052935d3b707c1be1fa51c71e4b61117ecb6cb5cd87f96df8477069babbeae1"
    sha256 cellar: :any_skip_relocation, big_sur:        "34e64ce4093cf7fea1e14f26090de3be887a83dc1882f65861da9ff6fd9393d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "469f27cec02e34c0008e679f6ef9805dfc7e09404fcaecb03e950aa2c5978d36"
  end

  depends_on "go" => :build

  def install
    goarch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    os = OS.kernel_name.downcase
    ENV["VERSION"] = version.to_s
    ENV["GOOS"] = os
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ENV["GOARCH"] = goarch

    system "make", "dist-for-os"
    bin.install "dist/#{os}-newrelic-infra_#{os}_#{goarch}/newrelic-infra"
    bin.install "dist/#{os}-newrelic-infra-ctl_#{os}_#{goarch}/newrelic-infra-ctl"
    bin.install "dist/#{os}-newrelic-infra-service_#{os}_#{goarch}/newrelic-infra-service"
    (var/"db/newrelic-infra").install "assets/licence/LICENSE.macos.txt" if OS.mac?
  end

  def post_install
    (etc/"newrelic-infra").mkpath
    (var/"log/newrelic-infra").mkpath
  end

  service do
    run [opt_bin/"newrelic-infra-service", "-config", etc/"newrelic-infra/newrelic-infra.yml"]
    log_path var/"log/newrelic-infra/newrelic-infra.log"
    error_log_path var/"log/newrelic-infra/newrelic-infra.stderr.log"
  end

  test do
    output = shell_output("#{bin}/newrelic-infra -validate")
    assert_match "config validation", output
  end
end
