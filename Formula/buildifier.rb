class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/v6.1.2.tar.gz"
  sha256 "977a0bd4593c8d4c8f45e056d181c35e48aa01ad4f8090bdb84f78dca42f47dc"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3974b7adbfd1d2b46d3c155bad8483787b41b1634f61b2d7f32cf6a094dcfe8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3974b7adbfd1d2b46d3c155bad8483787b41b1634f61b2d7f32cf6a094dcfe8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c3974b7adbfd1d2b46d3c155bad8483787b41b1634f61b2d7f32cf6a094dcfe8"
    sha256 cellar: :any_skip_relocation, ventura:        "30bb9ec77b62c01e70914d771c84a5ef3878ff3e7a379734f28b3a6b7c7c648a"
    sha256 cellar: :any_skip_relocation, monterey:       "30bb9ec77b62c01e70914d771c84a5ef3878ff3e7a379734f28b3a6b7c7c648a"
    sha256 cellar: :any_skip_relocation, big_sur:        "30bb9ec77b62c01e70914d771c84a5ef3878ff3e7a379734f28b3a6b7c7c648a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00704a6f66e6dd3623b23685e756e27ddad11a0da08fd9abf5b1458438574e23"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./buildifier"
  end

  test do
    touch testpath/"BUILD"
    system "#{bin}/buildifier", "-mode=check", "BUILD"
  end
end
