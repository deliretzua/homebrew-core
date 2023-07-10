require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-16.6.5.tgz"
  sha256 "8fd3044e20424096f98b634e28d07957f7e4ee4f212348995242cfacd6ceb6c0"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_ventura:  "8b5feb6805ba26f9c18347ed7c2bc8de45cfa28404de400575eb098a9957ca12"
    sha256                               arm64_monterey: "4910d2192cf82f743fb65d68b029a04637a550ddd2900c3b55bd926d6256968d"
    sha256                               arm64_big_sur:  "053d9065066bce627850b6e8041836456c191482d19847fa9eea31fc8acbb416"
    sha256                               ventura:        "64604dfbafae162a7e7796280251c055dd04fc180a778106432c9572a76bf265"
    sha256                               monterey:       "353098c71f91479cabc1ead265f3065b9e599847916cc18f93d1d4449a232485"
    sha256                               big_sur:        "4797030582209349d8e5381f0f542684daa8d1dc5a73a7e442c23988cb66a548"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12ad02d12eea3d1d7943769527d29f1b746cc87362e22ad8595ee5473f907fb2"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  on_linux do
    depends_on "libusb"
    depends_on "systemd" # for libudev
    depends_on "xz" # for liblzma
  end

  def install
    ENV.deparallelize
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/balena-cli/node_modules"
    node_modules.glob("{ffi-napi,ref-napi}/prebuilds/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

    (node_modules/"lzma-native/build").rmtree
    (node_modules/"usb").rmtree if OS.linux?

    term_size_vendor_dir = node_modules/"term-size/vendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries

    if OS.mac?
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir

      unless Hardware::CPU.intel?
        # Replace pre-built x86_64 binaries with native binaries
        %w[denymount macmount].each do |mod|
          (node_modules/mod/"bin"/mod).unlink
          system "make", "-C", node_modules/mod
        end
      end
    end

    # Replace universal binaries with their native slices.
    deuniversalize_machos
  end

  test do
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end
