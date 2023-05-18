class ServiceWeaver < Formula
  desc "Programming framework for writing and deploying cloud applications"
  homepage "https://serviceweaver.dev/"
  license "Apache-2.0"

  stable do
    url "https://github.com/ServiceWeaver/weaver/archive/refs/tags/v0.11.0.tar.gz"
    sha256 "0a35d28a07baf2844c587c8988e7bbb4a529df14b2b0bdfdf0f263ef0ac2a344"

    resource "weaver-gke" do
      url "https://github.com/ServiceWeaver/weaver-gke/archive/refs/tags/v0.11.0.tar.gz"
      sha256 "6f53478d2193a96598a21077b5ffc702927a937befd4cae588210543de190856"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b713fe3100a1b5403484586b789c1e7df9146592a25969b87f69038e36deec0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3c2e2bbb0879569ebe37fe35491b699c865178f5c790603f7284b3278f887e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33534e3bb688fa72239ea660f163b75264d7ca4ef9ad09dbb737f9abc70dab62"
    sha256 cellar: :any_skip_relocation, ventura:        "82d5188852159adb4339ec67b0152dde164222a15b20bd35ab1e23f601fba39c"
    sha256 cellar: :any_skip_relocation, monterey:       "77cc4da78d7d578dbbd47cee06a18a6d6e51c0debce5723d07d282fc9862ff6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "821fe08cd58cc3cddb67ffcf1828ed5ebf4b87daaf881d4eac9cf4fee8efb910"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7fa9b60653242185d345e66c7026c0ceabbbb095a1e135e92281e56386cc64b"
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
