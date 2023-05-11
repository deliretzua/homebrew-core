class Access < Formula
  desc "Easiest way to request and grant access without leaving your terminal"
  homepage "https://indent.com"
  url "https://github.com/indentapis/access.git",
      tag:      "v0.10.11",
      revision: "dd71b8b3d12e86c3d87dd78f10873469d97dc66c"
  license "Apache-2.0"
  head "https://github.com/indentapis/access.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8f0ccea9cc161ffc7d503af8d2f1c6d014a8a16a4456a88e3c4fbe3f56e3a74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8f0ccea9cc161ffc7d503af8d2f1c6d014a8a16a4456a88e3c4fbe3f56e3a74"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8f0ccea9cc161ffc7d503af8d2f1c6d014a8a16a4456a88e3c4fbe3f56e3a74"
    sha256 cellar: :any_skip_relocation, ventura:        "6912ee022be7fdb94c61b729de12789606d59a8950d363ae22bf93d054624dcd"
    sha256 cellar: :any_skip_relocation, monterey:       "6912ee022be7fdb94c61b729de12789606d59a8950d363ae22bf93d054624dcd"
    sha256 cellar: :any_skip_relocation, big_sur:        "6912ee022be7fdb94c61b729de12789606d59a8950d363ae22bf93d054624dcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ad0e7891cc1da6cb77bf68779b80033da65d19ae6c6a993f46c1f60d9e4fec3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.GitVersion=#{Utils.git_head}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/access"

    # Install shell completions
    generate_completions_from_executable(bin/"access", "completion")
  end

  test do
    test_file = testpath/"access.yaml"
    touch test_file
    system bin/"access", "config", "set", "space", "some-space"
    assert_equal "space: some-space", test_file.read.strip
  end
end
