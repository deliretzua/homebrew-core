class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.24.13",
      revision: "1f6327063e4c4e160d538da4c0be374d7093692d"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2e72e54cb4dd65af4c1eaf8064eeef7d7ce901f7daeb87ff68196a88d92b12e4"
    sha256 cellar: :any_skip_relocation, big_sur:       "af4f08986d4607d556d3cf949560a03392fc414c113a84633d25ce3c611d7f1b"
    sha256 cellar: :any_skip_relocation, catalina:      "27257b241576ac686c2ab97b5fee6e989bb68782171d5ca947f2ab63bb280354"
    sha256 cellar: :any_skip_relocation, mojave:        "81863151fa824dbc4f31eeb81ef8021a41f6f1605fce6d7e7ae884e5a57bd7cf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X github.com/derailed/k9s/cmd.version=#{version}
             -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}",
             *std_go_args
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
