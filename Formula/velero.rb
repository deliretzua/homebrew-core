class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://github.com/vmware-tanzu/velero"
  url "https://github.com/vmware-tanzu/velero/archive/v1.9.3.tar.gz"
  sha256 "294f63c2382c5c6570c5db8b20087e8053e5572b5bef7b4ec1df5db3d565c08b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "565d86664bc7a5be1635a2a66c7791872673339ba6b7398941fa27f3a9f49139"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "534de97857f9609a1a1189b6c3a8846164ee21c7064413eaafe30e528945f8c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e1f80abf8e987d3178fa9ea722bc16b7429de8f2fcc43494a9f6f846f36ffb0"
    sha256 cellar: :any_skip_relocation, monterey:       "3c895c7c3b96f2a755252775058ac0faa2a76838919c63292d9ea9f2f2d3f634"
    sha256 cellar: :any_skip_relocation, big_sur:        "f61d33ef415b939bf7a18641377e0fb50fb6e714f661c7a3ee48b0219b35e7a6"
    sha256 cellar: :any_skip_relocation, catalina:       "ad71b610d9e846d53339f53e9c91a62b0f310fbfc58fc7b732f3a38b7fac9be4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87dbfec02528dff580bef722ea3701413d22d4180a2f6aa73440047e21a1d044"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/vmware-tanzu/velero/pkg/buildinfo.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-installsuffix", "static", "./cmd/velero"

    generate_completions_from_executable(bin/"velero", "completion")
  end

  test do
    output = shell_output("#{bin}/velero 2>&1")
    assert_match "Velero is a tool for managing disaster recovery", output
    assert_match "Version: v#{version}", shell_output("#{bin}/velero version --client-only 2>&1")
    system bin/"velero", "client", "config", "set", "TEST=value"
    assert_match "value", shell_output("#{bin}/velero client config get 2>&1")
  end
end
