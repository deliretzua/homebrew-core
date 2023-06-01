class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.14.5.tar.gz"
  sha256 "eb1c88eef24425551682592e7a6d128fde659f2f7b69de10e7edb5e8806916f1"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb2f41dd7cb93c98f41616c6da215cc61e0f5c2601a8d34d0a72a10eb845ed60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9935ba51a49e0cd2dcc8aabe385015574710d3662c68696a9a914dd82dd55423"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7f1d31a2a61a86b6327c084389d081cfc74b358e43211292a9b5e03bbf5a675"
    sha256 cellar: :any_skip_relocation, ventura:        "ac82fbcfb04b1591b9b66a09adee9126b1a07efb04364fb3915b0dd3445cb715"
    sha256 cellar: :any_skip_relocation, monterey:       "07775f911e539bc429f922d204b0d55ee92e3b190811a8f5e1ea3db679d442a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "edbf4ece37b95852c5786ed1e06263eaad11e59b6ec28bcc25cbae8b1d531c00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6a4e67f3d0dac055913113f232418b72d842dadd3c6b1264fa25b8d52d2c31c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/cilium-cli/cli.Version=v#{version}"
    system "go", "build", *std_go_args(output: bin/"cilium", ldflags: ldflags), "./cmd/cilium"

    generate_completions_from_executable(bin/"cilium", "completion", base_name: "cilium")
  end

  test do
    assert_match("cilium-cli: v#{version}", shell_output("#{bin}/cilium version 2>&1"))
    assert_match('Cluster name "" is not valid', shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end
