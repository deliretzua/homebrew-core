class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.16.5.tar.gz"
  sha256 "f049aed88c40f02ff49274857660bc0bac1f8d5a4fa19d6abcd081aedf8b1036"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9543dcd256baa6c5a8b56e8c8708e5a699a1ef60976905d975ce67c68424f8ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5294a93a04e97d53acb2c9aba011d65c3f2a2848579169095af041f514b4ac2b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca7d84bd6d5adc00185e20ab77ab8fb1d591b487e69d2b6221a6e5c5070a807a"
    sha256 cellar: :any_skip_relocation, ventura:        "6f84cbd40e64aa77787b6ae656f134c0b4c86d5bb6ce26db13c1fb4c5fa4f4ab"
    sha256 cellar: :any_skip_relocation, monterey:       "add8863882e6794820612b768dc0af855b4eec388f63fb903539814df25f91ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c2db941693917788ce5c89426dd0753bd82626e778f758f3e19377f8b9b2641"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0eb29aecef686b674b661a62bb27c5097aa56935163805b3c458111c2c497380"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags

    generate_completions_from_executable(bin/"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin/"okteto init --context test 2>&1", 1)

    assert_match "Your context is not set",
      shell_output(bin/"okteto context list 2>&1", 1)
  end
end
