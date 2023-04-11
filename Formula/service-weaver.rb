class ServiceWeaver < Formula
  desc "Programming framework for writing and deploying cloud applications"
  homepage "https://serviceweaver.dev/"
  license "Apache-2.0"

  stable do
    url "https://github.com/ServiceWeaver/weaver/archive/refs/tags/v0.4.0.tar.gz"
    sha256 "c45d8b59c9c156e09b58badd4c3d3010305c19afb24b2aa3d056fe9204f0d9cd"

    resource "weaver-gke" do
      url "https://github.com/ServiceWeaver/weaver-gke/archive/refs/tags/v0.4.0.tar.gz"
      sha256 "21cf9022440a3a19cb32444ad805acb282d189b1790e72643643585e0d51681d"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0569f1888ca9710f48ac34a1e22df05c8a389fba843a7f4e703457c82c209f20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6387cc71d24f590fbac21c02ad424f506d445ca1f014ab3ed1f68a055c9f7f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5987b9e0003c9319a6bd2713d444ff2c51a73b147885679568624dafcad5a550"
    sha256 cellar: :any_skip_relocation, ventura:        "3d177d2d05a191b8ad2fa7357ca2ca2de54f3582f78a674b9a68b03cf72e9a64"
    sha256 cellar: :any_skip_relocation, monterey:       "525f4b01531d4e50242274f7b3af7ba12fc5008e339349d4c9be5474b8f0fddf"
    sha256 cellar: :any_skip_relocation, big_sur:        "7755fa1f9d0f182cd8035cec1d5ed5838d2fcda7568bc34c250191441eff29a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6964b710dfe0491e04c44388313e2b69c6c0ef0ead12e6f0c1cf08a5dd320cb"
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
