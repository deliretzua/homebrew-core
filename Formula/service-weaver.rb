class ServiceWeaver < Formula
  desc "Programming framework for writing and deploying cloud applications"
  homepage "https://serviceweaver.dev/"
  license "Apache-2.0"

  stable do
    url "https://github.com/ServiceWeaver/weaver/archive/refs/tags/v0.7.0.tar.gz"
    sha256 "fd1472dd9059da73c6eff229c9359677ef270dbdbe2f63ce228687fb87a6338b"

    resource "weaver-gke" do
      url "https://github.com/ServiceWeaver/weaver-gke/archive/refs/tags/v0.5.3.tar.gz"
      sha256 "497ead64073fdbffaab15a77e71d55942b5bbd3f221eb9bc7595da57060e1b65"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5b4f2898d29c038cab58a0ad9cf4793b85307ed96c9dbd34f50d19028dd855a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b520c4c9680be9f01837ec6226a7a4b788fe359f820a1d8f59de2eba023fe3d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7050112eb1a7e3232222d32c56f183ff4853349cda60219cec9c66e66e3e6934"
    sha256 cellar: :any_skip_relocation, ventura:        "9f3f04e7d47005356bac4895fefc2e56ef81174eb5cb5b2cc037bd6862071a2a"
    sha256 cellar: :any_skip_relocation, monterey:       "a852c1216454d6b795cd7679770da325b4366e0485d499177e9270613e073355"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6203bc4b957343f73f5cbb854d14c7f008df139c3d007fe121b5d092bd06bed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "528445508e58771e0c51f2f975eac75819ad02a71586c5e590e8f1ec57d4fe4c"
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
