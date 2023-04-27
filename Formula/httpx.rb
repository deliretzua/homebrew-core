class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/v1.3.0.tar.gz"
  sha256 "7f8f80a0b9fc03f8481c56365d043b927a85c87543fcf83aa212443c2fc3ca4a"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a496e80985e1645fa6a7af09de6e556a3131eb5dc851e97293988bf5451cede"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a496e80985e1645fa6a7af09de6e556a3131eb5dc851e97293988bf5451cede"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a496e80985e1645fa6a7af09de6e556a3131eb5dc851e97293988bf5451cede"
    sha256 cellar: :any_skip_relocation, ventura:        "9794a5b9418a3160447751fa75ac44c0245005fa88add33f02fa6a897d282f8b"
    sha256 cellar: :any_skip_relocation, monterey:       "9794a5b9418a3160447751fa75ac44c0245005fa88add33f02fa6a897d282f8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "9794a5b9418a3160447751fa75ac44c0245005fa88add33f02fa6a897d282f8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c771aad1b5711b2ce32cc470ddb608803c020d8368dfd61d1c679883e4c24ad4"
  end

  depends_on "go" => :build

  # Fix kIOMasterPortDefault symbol rename.
  # Remove when github.com/shoenig/go-m1cpu is bumped to v0.1.5 or newer.
  # Check: https://github.com/projectdiscovery/httpx/blob/main/go.mod#L110
  patch :DATA

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/httpx"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/httpx -silent -title -json -u example.org"))
    assert_equal 200, output["status_code"]
    assert_equal "Example Domain", output["title"]
  end
end

__END__
diff --git a/go.mod b/go.mod
index 7f6ccae..4b8efe6 100644
--- a/go.mod
+++ b/go.mod
@@ -107,7 +107,7 @@ require (
 	github.com/saintfish/chardet v0.0.0-20230101081208-5e3ef4b5456d // indirect
 	github.com/sashabaranov/go-openai v1.8.0 // indirect
 	github.com/shirou/gopsutil/v3 v3.23.3 // indirect
-	github.com/shoenig/go-m1cpu v0.1.4 // indirect
+	github.com/shoenig/go-m1cpu v0.1.5 // indirect
 	github.com/syndtr/goleveldb v1.0.0 // indirect
 	github.com/tidwall/btree v1.6.0 // indirect
 	github.com/tidwall/buntdb v1.2.10 // indirect
diff --git a/go.sum b/go.sum
index 097dd4e..797f347 100644
--- a/go.sum
+++ b/go.sum
@@ -241,8 +241,9 @@ github.com/sashabaranov/go-openai v1.8.0 h1:IZrNK/gGqxtp0j19F4NLGbmfoOkyDpM3oC9i
 github.com/sashabaranov/go-openai v1.8.0/go.mod h1:lj5b/K+zjTSFxVLijLSTDZuP7adOgerWeFyZLUhAKRg=
 github.com/shirou/gopsutil/v3 v3.23.3 h1:Syt5vVZXUDXPEXpIBt5ziWsJ4LdSAAxF4l/xZeQgSEE=
 github.com/shirou/gopsutil/v3 v3.23.3/go.mod h1:lSBNN6t3+D6W5e5nXTxc8KIMMVxAcS+6IJlffjRRlMU=
-github.com/shoenig/go-m1cpu v0.1.4 h1:SZPIgRM2sEF9NJy50mRHu9PKGwxyyTTJIWvCtgVbozs=
 github.com/shoenig/go-m1cpu v0.1.4/go.mod h1:Wwvst4LR89UxjeFtLRMrpgRiyY4xPsejnVZym39dbAQ=
+github.com/shoenig/go-m1cpu v0.1.5 h1:LF57Z/Fpb/WdGLjt2HZilNnmZOxg/q2bSKTQhgbrLrQ=
+github.com/shoenig/go-m1cpu v0.1.5/go.mod h1:Wwvst4LR89UxjeFtLRMrpgRiyY4xPsejnVZym39dbAQ=
 github.com/shoenig/test v0.6.3 h1:GVXWJFk9PiOjN0KoJ7VrJGH6uLPnqxR7/fe3HUPfE0c=
 github.com/shoenig/test v0.6.3/go.mod h1:byHiCGXqrVaflBLAMq/srcZIHynQPQgeyvkvXnjqq0k=
 github.com/sirupsen/logrus v1.3.0/go.mod h1:LxeOpSwHxABJmUn/MG1IvRgCAasNZTLOkJPxbbu5VWo=
