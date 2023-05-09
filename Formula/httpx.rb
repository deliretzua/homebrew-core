class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "07d314a37e9d93f884b9409c67eabd6cbe9bef0c9c7c30a85bf696ef5412447d"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed467d8830a6c6ef79ec7539678e2dc387eb2293e92ca267b6e7593ebf7a7424"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3ccd44e59358e6bcd74d170acc69d1154175cc15da60660b50d715ea3c797fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d023cad235e9f112864907c999ea0a215db91b91388483ec56942ce3d8db873a"
    sha256 cellar: :any_skip_relocation, ventura:        "e99c12d1b948a6de9e0240168279d3d78334336deb71780d103d549b6888463f"
    sha256 cellar: :any_skip_relocation, monterey:       "8f46e80e1835a5b1052ecd803915f44bfd3a34110f193739140c0916aca6a0ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "ddf779964cfd6321e16d33c18d7eb6bbe95f65502e58b2db88a6f940662f1df9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "716638d1f0ec97c6b06f5b6642e7a526a6b23a5fa5e2b6bbc479dab0ddcfa863"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/httpx"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/httpx -silent -title -json -u example.org"))
    assert_equal 200, output["status_code"]
    assert_equal "Example Domain", output["title"]
  end
end
