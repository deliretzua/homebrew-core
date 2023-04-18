class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/nginx-proxy/docker-gen"
  url "https://github.com/nginx-proxy/docker-gen/archive/0.10.4.tar.gz"
  sha256 "e7ad6a82191e72077e1bfd44252c02f5c2f23a4011f7ec4799c33363123db008"
  license "MIT"
  head "https://github.com/nginx-proxy/docker-gen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "133d139896cffc5686dcb8f5c05ea0788d4a639ffa94285c998f4aa3c6a49f1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "133d139896cffc5686dcb8f5c05ea0788d4a639ffa94285c998f4aa3c6a49f1e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "133d139896cffc5686dcb8f5c05ea0788d4a639ffa94285c998f4aa3c6a49f1e"
    sha256 cellar: :any_skip_relocation, ventura:        "79ae1949ebb9bf7a85ac01a263bfdeeca5ad7a67c668478dfd4c8e2ba52e414a"
    sha256 cellar: :any_skip_relocation, monterey:       "79ae1949ebb9bf7a85ac01a263bfdeeca5ad7a67c668478dfd4c8e2ba52e414a"
    sha256 cellar: :any_skip_relocation, big_sur:        "79ae1949ebb9bf7a85ac01a263bfdeeca5ad7a67c668478dfd4c8e2ba52e414a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50b0db1057d4a985e3ba53f459c5f701ff3e7902d626d6fcd6130627d81f97ea"
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
