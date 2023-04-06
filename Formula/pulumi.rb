class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.62.0",
      revision: "fb96f1db5fb94dfadc8401543df88ea061866520"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d1d1d8827681fc160b7b6c44e482fb10d23d1922f2d83accd86a717247f84fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e164fe3e652259b5ceeddeb3eef084740401b9ddce31190836726c6d28402b69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5f52ac09fa30629870f13221edf4d96f7d650044777ba5143dfdfc805cc13a2"
    sha256 cellar: :any_skip_relocation, ventura:        "14d27c70968713fd03b25b955785f32ae41d583fba8e86de8c132836b1b12af9"
    sha256 cellar: :any_skip_relocation, monterey:       "6ef4d5399633daab5c62064ad52851f9e28288a3ac660b86015013d1c413cd10"
    sha256 cellar: :any_skip_relocation, big_sur:        "84372c68252c21bd81c8a7ad8b8257e0fd506fc34021eaf24251f4f28508b0e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5fca09da5c83f1428f09137f6234cd6154eb8f1075bd9aee5b5b7819b45e85a"
  end

  depends_on "go" => :build

  def install
    cd "./sdk" do
      system "go", "mod", "download"
    end
    cd "./pkg" do
      system "go", "mod", "download"
    end

    system "make", "brew"

    bin.install Dir["#{ENV["GOPATH"]}/bin/pulumi*"]

    # Install shell completions
    generate_completions_from_executable(bin/"pulumi", "gen-completion")
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local://"
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    system "#{bin}/pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end
