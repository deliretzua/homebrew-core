class StructurizrCli < Formula
  desc "Command-line utility for Structurizr"
  homepage "https://structurizr.com"
  url "https://github.com/structurizr/cli/releases/download/v1.30.0/structurizr-cli-1.30.0.zip"
  sha256 "25bbe4ebf9ec18eccb7c7a86dbec1f3a001cdecbb044ce3ee23b382c5b4ba1a4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8e3011b1dce2872ea5d091a070c6d7e0e267f6037434d7f5ea86223a6697e655"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["*.bat"]
    libexec.install Dir["*"]
    (bin/"structurizr-cli").write_env_script libexec/"structurizr.sh", Language::Java.overridable_java_home_env
  end

  test do
    result = pipe_output("#{bin}/structurizr-cli").strip
    # not checking `Structurizr DSL` version as it is different binary
    assert_match "structurizr-cli: #{version}", result
    assert_match "Usage: structurizr push|pull|lock|unlock|export|validate|list|help [options]", result
  end
end
