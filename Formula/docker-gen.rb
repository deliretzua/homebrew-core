class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/nginx-proxy/docker-gen"
  url "https://github.com/nginx-proxy/docker-gen/archive/0.10.3.tar.gz"
  sha256 "3ab12a93c24540d5832bceede448a149ed88d203b337d6626797cdfb9d12026b"
  license "MIT"
  head "https://github.com/nginx-proxy/docker-gen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f072b5a4e6f258dc0eb36962ad96ac83b13a807a5e1ee5c37b347d3f3f7c424"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f072b5a4e6f258dc0eb36962ad96ac83b13a807a5e1ee5c37b347d3f3f7c424"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f072b5a4e6f258dc0eb36962ad96ac83b13a807a5e1ee5c37b347d3f3f7c424"
    sha256 cellar: :any_skip_relocation, ventura:        "625c9336fcda57d2eda3d2e5a080eda3ab4d6300995affb929f59335fe4baebe"
    sha256 cellar: :any_skip_relocation, monterey:       "625c9336fcda57d2eda3d2e5a080eda3ab4d6300995affb929f59335fe4baebe"
    sha256 cellar: :any_skip_relocation, big_sur:        "625c9336fcda57d2eda3d2e5a080eda3ab4d6300995affb929f59335fe4baebe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d42b00843a08279a3846f6048d80d002741abb2da4d298b1a8585947789293f"
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
