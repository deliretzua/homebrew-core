class ServiceWeaver < Formula
  desc "Programming framework for writing and deploying cloud applications"
  homepage "https://serviceweaver.dev/"
  license "Apache-2.0"

  stable do
    url "https://github.com/ServiceWeaver/weaver/archive/refs/tags/v0.18.0.tar.gz"
    sha256 "086cbb0a88c9631ea1400db5f0ab86d1798b3e7fac394a86c21deaae8113dbb5"

    resource "weaver-gke" do
      url "https://github.com/ServiceWeaver/weaver-gke/archive/refs/tags/v0.18.0.tar.gz"
      sha256 "d05e14ecf9324512627b68807d8503a46d6f4fb2ffdb18cfa664364f49b59d49"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c69c40590ce01f1405ac4ca9cb1c2fe02a7f6a8878800ae498ad45785ccc7e13"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb33e6e1472975276bf9ea220fd4029664651205fcc47635f93832f7960b8c8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a15b733a188c501344d924d282b924e95b75dac8667f964a71b38758054c7660"
    sha256 cellar: :any_skip_relocation, ventura:        "6a702a4769f703115105540f218d1feaf9c2a0c2bce47c3039ef8ff34e18247c"
    sha256 cellar: :any_skip_relocation, monterey:       "b51dadd6bf63c8a371128dbff5213c01b73c286d165eb3c70784d3c5ec4828e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7b0219c272c2d3828aac0b0282a0c59ba71a70fda399816379b96b674d8c62a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83ed12fbdca4e936a4a86cfc5c806fd1ac65a2da78a7c3da3c3b474761877c29"
  end

  head do
    url "https://github.com/ServiceWeaver/weaver.git", branch: "main"

    resource "weaver-gke" do
      url "https://github.com/ServiceWeaver/weaver-gke.git", branch: "main"
    end
  end

  depends_on "go" => :build

  conflicts_with "weaver", because: "both install a `weaver` binary"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"weaver"), "./cmd/weaver"
    resource("weaver-gke").stage do
      ["weaver-gke", "weaver-gke-local"].each do |f|
        system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/f), "./cmd/#{f}"
      end
    end
  end

  test do
    output = shell_output("#{bin}/weaver single status")
    assert_match "DEPLOYMENTS", output

    gke_output = shell_output("#{bin}/weaver gke status 2>&1", 1)
    assert_match "gcloud not installed", gke_output

    gke_local_output = shell_output("#{bin}/weaver gke-local status 2>&1", 1)
    assert_match "connect: connection refused", gke_local_output
  end
end
