class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/nginx-proxy/docker-gen"
  url "https://github.com/nginx-proxy/docker-gen/archive/0.10.5.tar.gz"
  sha256 "fb9c22563e1b7c87020633c4c4ea240d2e4b1c1f82d55c8e2174b4a5835c1c7a"
  license "MIT"
  head "https://github.com/nginx-proxy/docker-gen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e574ad2d5ca71f67768d30a43a7e3b21ce9506ff66b72cde41b8ee3644d2f11"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e574ad2d5ca71f67768d30a43a7e3b21ce9506ff66b72cde41b8ee3644d2f11"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e574ad2d5ca71f67768d30a43a7e3b21ce9506ff66b72cde41b8ee3644d2f11"
    sha256 cellar: :any_skip_relocation, ventura:        "b526141b801a270b85aa1765ffd249bb45f65113186e277f1e952db66e3c4401"
    sha256 cellar: :any_skip_relocation, monterey:       "b526141b801a270b85aa1765ffd249bb45f65113186e277f1e952db66e3c4401"
    sha256 cellar: :any_skip_relocation, big_sur:        "b526141b801a270b85aa1765ffd249bb45f65113186e277f1e952db66e3c4401"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb73cb9feed232bb32da903e6cb3739676fd365be3c8529586ef186d7af5ebf1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/docker-gen"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docker-gen --version")
  end
end
