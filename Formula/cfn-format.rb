class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/v1.4.2.tar.gz"
  sha256 "fead74b5e0663ca598887d44f0c681e9a2501eccc8f7f1d816041c1b2531deb8"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5568c8221924546b0f72ee8bb84102d71760c2da84b100dc12701bee36f2ab8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5568c8221924546b0f72ee8bb84102d71760c2da84b100dc12701bee36f2ab8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5568c8221924546b0f72ee8bb84102d71760c2da84b100dc12701bee36f2ab8d"
    sha256 cellar: :any_skip_relocation, ventura:        "84451cc8ab2dc329ef0737159e328633270fd0965f79709a283e7a1cfa506848"
    sha256 cellar: :any_skip_relocation, monterey:       "84451cc8ab2dc329ef0737159e328633270fd0965f79709a283e7a1cfa506848"
    sha256 cellar: :any_skip_relocation, big_sur:        "84451cc8ab2dc329ef0737159e328633270fd0965f79709a283e7a1cfa506848"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "644f601b67bb9657bc68e8266a694515fec497701858bcf88f60aa05a8fb3a35"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "cmd/cfn-format/main.go"
  end

  test do
    (testpath/"test.template").write <<~EOS
      Resources:
        Bucket:
          Type: AWS::S3::Bucket
    EOS
    assert_equal "test.template: formatted OK", shell_output("#{bin}/cfn-format -v test.template").strip
  end
end
