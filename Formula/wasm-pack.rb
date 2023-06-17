class WasmPack < Formula
  desc "Your favorite rust -> wasm workflow tool!"
  homepage "https://rustwasm.github.io/wasm-pack/"
  url "https://github.com/rustwasm/wasm-pack/archive/v0.12.0.tar.gz"
  sha256 "684a2fb39691c8231b05e5c9fb0cacf6155f0617e0458cae0cd1b5ec2d8f9600"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rustwasm/wasm-pack.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ca7ad2586cdaea9c2c24a8deeb90fceb76f892035fc01129582cf7f18e0abff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "517ca883b5067835edbe808eecdbcfaa2b7001b242aba3dc28bd9ed0dd7177ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb5b684a6e5c8bb89c34d94361f8cf567ce32f767a8ab4bcbb3ccc561f7ea4d4"
    sha256 cellar: :any_skip_relocation, ventura:        "6b0a5bfb7b266dc4833cb1dc082e33bbbf17a3bbb0e05638cbf0ddafbc45466b"
    sha256 cellar: :any_skip_relocation, monterey:       "9c7a72b9c37858a0cad496c637484a6a75d5fafd6197864a772dfd0674eb022f"
    sha256 cellar: :any_skip_relocation, big_sur:        "de900691d6f8be8fb3dd1e41b537e997fa2281e0897cb038ae8f305272aef8c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26d1b4f9ae53cb7bd95d550a2d7d7661ce1e1bfa81b830f9c9a2da6d4b0bb451"
  end

  depends_on "rust" => :build
  depends_on "rustup-init"

  # Restore `--version` command, remove in next release
  patch do
    url "https://github.com/rustwasm/wasm-pack/commit/91870e497d7212db40fc4ff5453233fc3fa5546d.patch?full_index=1"
    sha256 "148006151e4fe202287b278d1269bef8ebcf30bdc7c946027cdf25e26c72bfe1"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "wasm-pack #{version}", shell_output("#{bin}/wasm-pack --version")

    system "#{Formula["rustup-init"].bin}/rustup-init", "-y", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

    system bin/"wasm-pack", "new", "hello-wasm"
    system bin/"wasm-pack", "build", "hello-wasm"
    assert_predicate testpath/"hello-wasm/pkg/hello_wasm_bg.wasm", :exist?
  end
end
