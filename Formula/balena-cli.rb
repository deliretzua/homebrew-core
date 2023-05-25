require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-16.5.0.tgz"
  sha256 "71908f0207065813d4648c1783c133650efe693927be357d933830792470ffc1"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_ventura:  "4b480347e5b70276f4f7389924a30fd8ab8f0d49d0c4df348319b4ffbb9789b5"
    sha256                               arm64_monterey: "d1e3f4c53b007fc12992a9ee016b37a801adc4ad48814bdccf94c341196ca0b3"
    sha256                               arm64_big_sur:  "0cf7e3867e38ca55bf6d44e55edd73a971eee201821a6e7fce1d47bdf3528d4b"
    sha256                               ventura:        "0700ddfe2094b3ca89c0b8b8134c7ab1681328f59c96d1bd1a6425c0b5d85c25"
    sha256                               monterey:       "b81b117a2423de59e3ddc3b0f643b7995e31eb5df73de1803caf3ac41ba2cae1"
    sha256                               big_sur:        "11be3403cb5d0094bfa7d899ed4e871a86fcd0c8684aae959f3c64aa68b98760"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b912d8a8d4f48bb77e3daeea9b445130a677fde4acfaa0d073f2afa6da8f0e68"
  end

  depends_on "node@16"

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
    system Formula["node@16"].opt_bin/"npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"balena").write_env_script libexec/"bin/balena", PATH: "#{Formula["node@16"].opt_bin}:${PATH}"

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
