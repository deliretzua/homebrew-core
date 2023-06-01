require "language/node"

class AwsAmplify < Formula
  desc "Build full-stack web and mobile apps in hours. Easy to start, easy to scale"
  homepage "https://aws.amazon.com/amplify"
  url "https://registry.npmjs.org/@aws-amplify/cli-internal/-/cli-internal-12.0.3.tgz"
  sha256 "1f63a5561c2c1bc9c7e8cc5d3d61811752228dbfd69551807fbc120d5ce47bb6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e722bb17a9c1eb9f9267f6c9951351a164af4850f3c05bf62d6fd2ad4d7ea45d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e722bb17a9c1eb9f9267f6c9951351a164af4850f3c05bf62d6fd2ad4d7ea45d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e722bb17a9c1eb9f9267f6c9951351a164af4850f3c05bf62d6fd2ad4d7ea45d"
    sha256 cellar: :any_skip_relocation, ventura:        "e31e6465b25f1aff918e037cd47af183d996dd0d4f2888ce9494754c0dc2c951"
    sha256 cellar: :any_skip_relocation, monterey:       "e31e6465b25f1aff918e037cd47af183d996dd0d4f2888ce9494754c0dc2c951"
    sha256 cellar: :any_skip_relocation, big_sur:        "e31e6465b25f1aff918e037cd47af183d996dd0d4f2888ce9494754c0dc2c951"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "609241699fcb1575326b11b3675ac743ba0271c55d75b664fe9e89f8f74fc204"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    unless Hardware::CPU.intel?
      rm_rf "#{libexec}/lib/node_modules/@aws-amplify/cli-internal/node_modules" \
            "/@aws-amplify/amplify-frontend-ios/resources/amplify-xcode"
    end

    # Remove non-native libsqlite4java files
    os = OS.kernel_name.downcase
    if Hardware::CPU.intel?
      arch = if OS.mac?
        "x86_64"
      else
        "amd64"
      end
    elsif OS.mac? # apple silicon
      arch = "aarch64"
    end
    node_modules = libexec/"lib/node_modules/@aws-amplify/cli-internal/node_modules"
    (node_modules/"amplify-dynamodb-simulator/emulator/DynamoDBLocal_lib").glob("libsqlite4java-*").each do |f|
      rm f if f.basename.to_s != "libsqlite4java-#{os}-#{arch}"
    end

    # Replace universal binaries with native slices
    deuniversalize_machos node_modules/"fsevents/fsevents.node"
  end

  test do
    require "open3"

    Open3.popen3(bin/"amplify", "status", "2>&1") do |_, stdout, _|
      assert_match "No Amplify backend project files detected within this folder.", stdout.read
    end

    assert_match version.to_s, shell_output(bin/"amplify version")
  end
end
