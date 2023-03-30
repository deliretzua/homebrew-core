class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.77.0.tar.gz"
  sha256 "4f4dcf46209a96800715ff1178ca66f2dfc2c77018ccb23ebd27bab49d06d234"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70059943855aface8090186d27b2dd9a168eee83d54a8a8b2b22859f312b5ec2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cdf86712fad84ba8ea85ab85012a20f614034ff8875d829d1cf047c29b3069ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae18da81e2f066d58031250d08a07f6ce9bc1e580ad02aa524114f46b15ad148"
    sha256 cellar: :any_skip_relocation, ventura:        "fa5db6d1ba710518f155d63f5cb4e2c1e962f8176856b183c85ba8917d5cf351"
    sha256 cellar: :any_skip_relocation, monterey:       "b64f1ccc5819f8ca9d1b167af30506952d274cfa9fcc1eefb06e128b7faab615"
    sha256 cellar: :any_skip_relocation, big_sur:        "bdbfb59813744a3cf8cdb3e83776026daf44f31cba4f1429524ed0f5a257f8c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d93eb1e835bec4da6d3038b82355829c74da44fce65862e330c77d0517d4780b"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "pkg-config" => :build
  end

  conflicts_with cask: "visual-studio-code"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    ENV["VSCODE_CLI_NAME_LONG"] = "Code OSS"
    ENV["VSCODE_CLI_VERSION"] = version

    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    assert_match "Successfully removed all unused servers",
      shell_output("#{bin}/code tunnel prune")
    assert_match version.to_s, shell_output("#{bin}/code --version")

    linked_libraries = [
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ]
    linked_libraries << (Formula["openssl@3"].opt_lib/shared_library("libcrypto")) if OS.mac?

    linked_libraries.each do |library|
      assert check_binary_linkage(bin/"code", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
