require "language/node"

class VueCli < Formula
  desc "Standard Tooling for Vue.js Development"
  homepage "https://cli.vuejs.org/"
  url "https://registry.npmjs.org/@vue/cli/-/cli-5.0.7.tgz"
  sha256 "9067da4a56d4cb3d77ebdb8a27f0544e099f1cf3cbff27993efbd1c2e81d6011"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8aacba6699ae253fecf334a30052cf22d357db433913dd81cb360051dedebfd7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8aacba6699ae253fecf334a30052cf22d357db433913dd81cb360051dedebfd7"
    sha256 cellar: :any_skip_relocation, monterey:       "c54b9bc9bf2e873c45d1836471ff4c8562efebcddca77a16beaac630f1c02fed"
    sha256 cellar: :any_skip_relocation, big_sur:        "c54b9bc9bf2e873c45d1836471ff4c8562efebcddca77a16beaac630f1c02fed"
    sha256 cellar: :any_skip_relocation, catalina:       "c54b9bc9bf2e873c45d1836471ff4c8562efebcddca77a16beaac630f1c02fed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f09a4ee62ace67d15b1a08f90a758cbc34abbb7a3b96530b8eb532d6a2cd875"
  end

  depends_on "node"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove vendored pre-built binary `terminal-notifier`
    node_notifier_vendor_dir = libexec/"lib/node_modules/@vue/cli/node_modules/node-notifier/vendor"
    node_notifier_vendor_dir.rmtree # remove vendored pre-built binaries

    if OS.mac?
      terminal_notifier_dir = node_notifier_vendor_dir/"mac.noindex"
      terminal_notifier_dir.mkpath

      # replace vendored `terminal-notifier` with our own
      terminal_notifier_app = Formula["terminal-notifier"].opt_prefix/"terminal-notifier.app"
      ln_sf terminal_notifier_app.relative_path_from(terminal_notifier_dir), terminal_notifier_dir
    end
  end

  test do
    (testpath/".vuerc").write <<~EOS
      {
        "useTaobaoRegistry": false,
        "packageManager": "yarn"
      }
    EOS

    assert_match "yarn", shell_output(bin/"vue config")
    assert_match "npm", shell_output(bin/"vue info")
  end
end
