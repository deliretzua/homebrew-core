class StructurizrCli < Formula
  desc "Command-line utility for Structurizr"
  homepage "https://structurizr.com"
  url "https://github.com/structurizr/cli/releases/download/v1.31.0/structurizr-cli-1.31.0.zip"
  sha256 "c934aed6c4f08339368386140d62e6e13aac944892cfa97340c2ff59eb92ad18"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "07c73ccd1f9d4a23087768da474ee627857d54534be50866db13c4c4e64e419b"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["*.bat"]
    libexec.install Dir["*"]
    (bin/"structurizr-cli").write_env_script libexec/"structurizr.sh", Language::Java.overridable_java_home_env
  end

  test do
    result = pipe_output("#{bin}/structurizr-cli").strip
    assert_match "Usage: structurizr push|pull|lock|unlock|export|validate|list|version|help [options]", result

    assert_match "structurizr-cli: #{version}", shell_output("#{bin}/structurizr-cli version")
  end
end
