require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-1.17.0.tgz"
  sha256 "9054e94d444cf0ef52fbb74acdd6b6faeea4936f33ad0c720491baafe33cec2e"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4a33f50a1759e1c132d0747ad3e8f03e97d66d8207bc8192b8a1dc018910a614"
    sha256 cellar: :any_skip_relocation, big_sur:       "5bc2d8ce3bb4fc801cfbe0406014811d745132ea58abcf22e07eae13ce333b78"
    sha256 cellar: :any_skip_relocation, catalina:      "5bc2d8ce3bb4fc801cfbe0406014811d745132ea58abcf22e07eae13ce333b78"
    sha256 cellar: :any_skip_relocation, mojave:        "5bc2d8ce3bb4fc801cfbe0406014811d745132ea58abcf22e07eae13ce333b78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39271a6b8270b3e219cf5df9df343ba7c68a6b71bd48cf8bf1c37d75c53742d6"
  end

  depends_on "node"

  # remove in next release
  # ref https://github.com/bitwarden/cli/commit/347ebb5b3699e39926cc7d584b3599dc62b0e79d
  patch :DATA

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal 10, shell_output("#{bin}/bw generate --length 10").chomp.length

    output = pipe_output("#{bin}/bw encode", "Testing", 0)
    assert_equal "VGVzdGluZw==", output.chomp
  end
end

__END__
diff --git a/package.json b/package.json
index d116a89..b79f591 100644
--- a/package.json
+++ b/package.json
@@ -49,8 +49,16 @@
         "assets": "./build/**/*"
     },
     "devDependencies": {
+        "@types/inquirer": "^7.3.1",
         "@types/jsdom": "^16.2.10",
+        "@types/lowdb": "^1.0.10",
+        "@types/lunr": "^2.3.3",
         "@types/node": "^14.17.1",
+        "@types/node-fetch": "^2.5.10",
+        "@types/node-forge": "^0.9.7",
+        "@types/papaparse": "^5.2.5",
+        "@types/tldjs": "^2.3.0",
+        "@types/zxcvbn": "^4.4.1",
         "clean-webpack-plugin": "^3.0.0",
         "copy-webpack-plugin": "^6.4.0",
         "cross-env": "^7.0.3",
@@ -65,14 +73,22 @@
         "webpack-node-externals": "^3.0.0"
     },
     "dependencies": {
-        "@bitwarden/jslib-common": "file:jslib/common",
-        "@bitwarden/jslib-node": "file:jslib/node",
+        "big-integer": "1.6.48",
+        "browser-hrtime": "^1.1.8",
+        "chalk": "^4.1.1",
         "commander": "7.2.0",
         "form-data": "4.0.0",
+        "https-proxy-agent": "5.0.0",
         "inquirer": "8.0.0",
         "jsdom": "^16.5.3",
+        "lowdb": "1.0.0",
+        "lunr": "^2.3.9",
+        "node-fetch": "^2.6.1",
         "node-forge": "0.10.0",
-        "open": "^8.0.8"
+        "open": "^8.0.8",
+        "papaparse": "^5.3.0",
+        "tldjs": "^2.3.1",
+        "zxcvbn": "^4.4.2"
     },
     "engines": {
         "node": "~14",
