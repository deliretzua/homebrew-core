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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "872adda191ab6d5dad8c1367fd4306e63b854f8bf1b3d632b4965e583a4197ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ffded6b252d39bfe05a0fe21faaaeb8a9eaca775ea2abf575f8056897aa687d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3e4b098eebcea88655146ca649a1307ff3907719fa31125904c4c1326ddac44"
    sha256 cellar: :any_skip_relocation, ventura:        "a46277a35d7056e1c8715f8c298f373561d35137697656d291b280f5939b8941"
    sha256 cellar: :any_skip_relocation, monterey:       "c73eab6d9abd896b5d933215886aa68177bfcf979a80c42952bff7613b7f10f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "051883d79e3ee467c810c4b2b5ab22957864877901e6e99abdfd80ffb5fa865a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "325f8dc248244b8c27d56e67766b1f9d70b6cfe71559e1be5f0e190615f9d847"
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
