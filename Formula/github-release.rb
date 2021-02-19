class GithubRelease < Formula
  desc "Create and edit releases on Github (and upload artifacts)"
  homepage "https://github.com/github-release/github-release"
  url "https://github.com/github-release/github-release/archive/v0.10.0.tar.gz"
  sha256 "79bfaa465f549a08c781f134b1533f05b02f433e7672fbaad4e1764e4a33f18a"
  license "MIT"
  head "https://github.com/github-release/github-release.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "c1965bbd4a0613203aeb88b46947d341d2d74453c7b3e1f964c731fec2557220"
    sha256 cellar: :any_skip_relocation, catalina: "b4117cdc7da244a1aad14cd05b02b2d8eafdbf93f241f2fffcb16ae93d2c2cf3"
    sha256 cellar: :any_skip_relocation, mojave:   "104bb9d23aa21c9b628ab812da084e238709790f63f9bb6c080d1514dcd8710c"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    system "make"
    bin.install "github-release"
  end

  test do
    system "#{bin}/github-release", "info", "--user", "github-release",
                                            "--repo", "github-release",
                                            "--tag", "v#{version}"
  end
end
