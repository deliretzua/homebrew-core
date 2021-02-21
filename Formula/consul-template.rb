class ConsulTemplate < Formula
  desc "Generic template rendering and notifications with Consul"
  homepage "https://github.com/hashicorp/consul-template"
  url "https://github.com/hashicorp/consul-template.git",
      tag:      "v0.25.2",
      revision: "870905de57f085588c3b718b779d8550aefc5dcf"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul-template.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5aa4fc41916cedf03968b7f7b1264acd67884f5277dfebd0c072185457b061f8"
    sha256 cellar: :any_skip_relocation, big_sur:       "978bab61f0209e37b5a14a1af8d9b55a767701cb5cded8107e9c7447e5e0b78d"
    sha256 cellar: :any_skip_relocation, catalina:      "79c0b42239bae3e2771b9cce86d2e816654126aa6c5907be3999eadec34ecd8a"
    sha256 cellar: :any_skip_relocation, mojave:        "169f7d647729d546330b8268f5e07eb378fc95e35831fb6f24d508901f607499"
    sha256 cellar: :any_skip_relocation, high_sierra:   "37f32e5b0d9e2ffc20846be7f4e97607e76f5b27b29cf015c941c9c03cc506f4"
  end

  depends_on "go" => :build

  def install
    project = "github.com/hashicorp/consul-template"
    ldflags = %W[
      -s -w
      -X #{project}/version.Name=consul-template
      -X #{project}/version.GitCommit=#{Utils.git_short_head}
    ]
    system "go", "build", "-ldflags", ldflags.join(" "), *std_go_args
    prefix.install_metafiles
  end

  test do
    (testpath/"template").write <<~EOS
      {{"homebrew" | toTitle}}
    EOS
    system bin/"consul-template", "-once", "-template", "template:test-result"
    assert_equal "Homebrew", (testpath/"test-result").read.chomp
  end
end
