class Rospo < Formula
  desc "🐸 Simple, reliable, persistent ssh tunnels with embedded ssh server"
  homepage "https://github.com/ferama/rospo"
  url "https://github.com/ferama/rospo/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "275645d216b29b430b1c65bc7ae774492a31026c3ac8424a7dc8f278faf3c334"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8569bfb865ea5fd1515f125e679f1e2684d532217e50ed5e7f05acbf2140fcf9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8569bfb865ea5fd1515f125e679f1e2684d532217e50ed5e7f05acbf2140fcf9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8569bfb865ea5fd1515f125e679f1e2684d532217e50ed5e7f05acbf2140fcf9"
    sha256 cellar: :any_skip_relocation, ventura:        "c2076cb5b87a40aaacc32af680366b6b823295d10c27c6e4bdbf7d9a08a086d8"
    sha256 cellar: :any_skip_relocation, monterey:       "c2076cb5b87a40aaacc32af680366b6b823295d10c27c6e4bdbf7d9a08a086d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2076cb5b87a40aaacc32af680366b6b823295d10c27c6e4bdbf7d9a08a086d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3cc39db6d0b260644d42a3bd98141be5e4ede2c7f5d76dac120e264490a3884"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X 'github.com/ferama/rospo/cmd.Version=#{version}'")

    generate_completions_from_executable(bin/"rospo", "completion")
  end

  test do
    system bin/"rospo", "-v"
    system bin/"rospo", "keygen", "-s"
    assert_predicate testpath/"identity", :exist?
    assert_predicate testpath/"identity.pub", :exist?
  end
end
