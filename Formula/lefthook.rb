class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "c776f585e06465e94f49e1dd49989fc6a41bf64c7e9d43339ed8fe9fa6f37b6f"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dfadd6d5c3f8279e7d7ef29cd8a913898f10104ec707e4086f11eb16fbfc1ab8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfadd6d5c3f8279e7d7ef29cd8a913898f10104ec707e4086f11eb16fbfc1ab8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dfadd6d5c3f8279e7d7ef29cd8a913898f10104ec707e4086f11eb16fbfc1ab8"
    sha256 cellar: :any_skip_relocation, ventura:        "f50a31d9c7f9d6ece4c7c384ebc0720927e03cd9265263cf3f22078af6dab2f4"
    sha256 cellar: :any_skip_relocation, monterey:       "f50a31d9c7f9d6ece4c7c384ebc0720927e03cd9265263cf3f22078af6dab2f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "f50a31d9c7f9d6ece4c7c384ebc0720927e03cd9265263cf3f22078af6dab2f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de9cbfd8022e684a63fda7a3583f34d013f05b882dc1fe51112d58ec76b056e9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
