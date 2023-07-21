class StructurizrCli < Formula
  desc "Command-line utility for Structurizr"
  homepage "https://structurizr.com"
  url "https://github.com/structurizr/cli/releases/download/v1.31.1/structurizr-cli-1.31.1.zip"
  sha256 "3a2f60693ab0c91fab943d49d7c6f66969129aa24448659d19527d4f79067ffa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f559a6553ba7dd2322058493a53aedd7edbbc828fd76f8b37366c613538602dc"
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
