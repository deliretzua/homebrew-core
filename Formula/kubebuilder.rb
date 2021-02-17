class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      tag:      "v2.3.2",
      revision: "5da27b892ae310e875c8719d94a5a04302c597d0"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kubebuilder.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6c271a2044413fe81d9c4671efbd2a66bce5ee9693731bfb2001292be1901a76"
    sha256 cellar: :any_skip_relocation, big_sur:       "c9fbe3f2af36d56afc501528827dd63aa7c2e450ae55d29372ea83b717b34d59"
    sha256 cellar: :any_skip_relocation, catalina:      "b587ddd6d67b12a7fd2635f8f4da56402133a036fe79e635b08427b401a9b71b"
    sha256 cellar: :any_skip_relocation, mojave:        "7de399f00ecd47e3150e05d213a44886f499456ed5480c095100e329203ab399"
    sha256 cellar: :any_skip_relocation, high_sierra:   "62040031af53761dbe639796b5dc95278be2a048380f691563fb9cd4ef7f8041"
  end

  depends_on "git-lfs" => :build
  depends_on "go"

  def install
    system "make", "build"
    bin.install "bin/kubebuilder"
    prefix.install_metafiles
  end

  test do
    mkdir "test" do
      system "#{bin}/kubebuilder", "init",
        "--repo=github.com/example/example-repo", "--domain=example.com",
        "--license=apache2", "--owner='The Example authors'", "--fetch-deps=false"
    end
  end
end
