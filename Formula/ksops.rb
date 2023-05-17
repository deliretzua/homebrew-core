class Ksops < Formula
  desc "Flexible Kustomize Plugin for SOPS Encrypted Resources"
  homepage "https://github.com/viaduct-ai/kustomize-sops"
  url "https://github.com/viaduct-ai/kustomize-sops/archive/refs/tags/v4.1.3.tar.gz"
  sha256 "2e24b1943788ec319a2ccb25cef87965cf73f21a052d0480ec5103f640e3c070"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "feb27f880b75984388ade05712fb935560c82b6b4b5f508921676ea9b040a068"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67fd64b6871dd65798b2b88ce1841e9466402df37cbefc8be7ba943e5e4182f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "feb27f880b75984388ade05712fb935560c82b6b4b5f508921676ea9b040a068"
    sha256 cellar: :any_skip_relocation, ventura:        "f6697cb9bd64318f6e900471f10bf730de268ec1bf344e6594b128358c12065f"
    sha256 cellar: :any_skip_relocation, monterey:       "f6697cb9bd64318f6e900471f10bf730de268ec1bf344e6594b128358c12065f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6697cb9bd64318f6e900471f10bf730de268ec1bf344e6594b128358c12065f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93c8ea6b937ac829a1588663ab00b38d084856826ff2a731cbf2a88242558f3a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"secret-generator.yaml").write <<~EOS
      apiVersion: viaduct.ai/v1
      kind: ksops
      metadata:
        name: secret-generator
        annotations:
          config.kubernetes.io/function: |
            exec:
              path: ksops
      files: []
    EOS
    system bin/"ksops", testpath/"secret-generator.yaml"
  end
end
