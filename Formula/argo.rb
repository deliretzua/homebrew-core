class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo-workflows.git",
      tag:      "v3.4.9",
      revision: "b76329f3a2dedf4c76a9cac5ed9603ada289c8d0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dee89e37a712af9820368605503f453e676c02785c029a35a5aba153ebbb02fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c99a8e12f697bdba6ed854dcedf64d0ab38987d4bedca6865df20f9c05cd176"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3df47afee89e73928e5a8413d27de79d786e4e1dd57eee08589695e766140ee0"
    sha256 cellar: :any_skip_relocation, ventura:        "4d233d95ed962f4002e9257a036ffa289523f3d54ffbb8abc697846e3ba472ed"
    sha256 cellar: :any_skip_relocation, monterey:       "07f2fbb50264f4c1bd7befd092c5db08a9aa1c1a7196fbcb3f049a13a01d4702"
    sha256 cellar: :any_skip_relocation, big_sur:        "f11e1ef009a1f1c5d1c5ec86e6d39bd282a977e7f285aa285efec808a128657d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d087f9f331f2e8166ff87001ca42713e3c422f42efe2cb26372ad712e54c9a17"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  # patch to fix `Error: error:0308010C:digital envelope routines::unsupported`
  # upstream PR ref, https://github.com/argoproj/argo-workflows/pull/11410
  patch :DATA

  def install
    # this needs to be remove to prevent multiple 'operation not permitted' errors
    inreplace "Makefile", "CGO_ENABLED=0", ""
    system "make", "dist/argo"
    bin.install "dist/argo"

    generate_completions_from_executable(bin/"argo", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match "argo:",
      shell_output("#{bin}/argo version")

    # argo consumes the Kubernetes configuration with the `--kubeconfig` flag
    # Since it is an empty file we expect it to be invalid
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/argo lint --kubeconfig ./kubeconfig ./kubeconfig 2>&1", 1)
  end
end

__END__
diff --git a/ui/package.json b/ui/package.json
index 2ecd358b1..aa27d9c14 100644
--- a/ui/package.json
+++ b/ui/package.json
@@ -6,7 +6,7 @@
         "src"
     ],
     "scripts": {
-        "build": "rm -Rf dist && NODE_OPTIONS='' NODE_ENV=production webpack --mode production --config ./src/app/webpack.config.js",
+        "build": "rm -Rf dist && NODE_OPTIONS='--openssl-legacy-provider' NODE_ENV=production webpack --mode production --config ./src/app/webpack.config.js",
         "start": "NODE_OPTIONS='--no-experimental-fetch' webpack-dev-server --config ./src/app/webpack.config.js",
         "lint": "tslint --fix -p ./src/app",
         "test": "jest"
