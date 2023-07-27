class StructurizrCli < Formula
  desc "Command-line utility for Structurizr"
  homepage "https://structurizr.com"
  url "https://github.com/structurizr/cli/releases/download/v1.32.1/structurizr-cli-1.32.1.zip"
  sha256 "94532284f70d1ecf2b46a91123371f12fb4c8fd60535070f1e28843395b7a2be"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2dde23366c4f18eb0b1fd42104dff0e35b2b94fa9a2a7d0c02cb5dbc7ba0a2c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2dde23366c4f18eb0b1fd42104dff0e35b2b94fa9a2a7d0c02cb5dbc7ba0a2c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2dde23366c4f18eb0b1fd42104dff0e35b2b94fa9a2a7d0c02cb5dbc7ba0a2c4"
    sha256 cellar: :any_skip_relocation, ventura:        "2dde23366c4f18eb0b1fd42104dff0e35b2b94fa9a2a7d0c02cb5dbc7ba0a2c4"
    sha256 cellar: :any_skip_relocation, monterey:       "2dde23366c4f18eb0b1fd42104dff0e35b2b94fa9a2a7d0c02cb5dbc7ba0a2c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "2dde23366c4f18eb0b1fd42104dff0e35b2b94fa9a2a7d0c02cb5dbc7ba0a2c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2f5dc40bdd851169ae641756b054721144faeb24d417807ad64401e04c6e229"
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
