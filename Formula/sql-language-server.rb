require "language/node"

class SqlLanguageServer < Formula
  desc "Language Server for SQL"
  homepage "https://github.com/joe-re/sql-language-server"
  url "https://registry.npmjs.org/sql-language-server/-/sql-language-server-1.5.2.tgz"
  sha256 "428392c2be8dd14c046bcadeb9be8daa603e802bd62224ec6b9a41f37280104f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0d7f64916ba29684e66abd182803a968173727c5cde235181e5fe552cd2141b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41f34e5f4d50676ef2e2df1c0e0361184f1eb9ca4eaeea0c9b8f1680ef28cd12"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3887b24d9b2f2550484e52c0c4b7ce1605844fae5e67d7634d4a612e743d7aa"
    sha256 cellar: :any_skip_relocation, ventura:        "995ea55fedcf87ab5e4c02320c1af65a5765507e5abbac73782c3785b020935c"
    sha256 cellar: :any_skip_relocation, monterey:       "c037154380ca3d81e5d8a6053ca0b86c804a38f7bd22bb56ca5cd13af9db8731"
    sha256 cellar: :any_skip_relocation, big_sur:        "0fe81205302b16b29e6e6f3254e260b057c87af45b3ec2604aabe81e1b901516"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "125a38f3b07222b729d7778000e84feffe7b2347bfa2c6c5481fd1ac81439a36"
  end

  depends_on "node"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove vendored pre-built binary `terminal-notifier`
    node_notifier_vendor_dir = libexec/"lib/node_modules/sql-language-server/node_modules/node-notifier/vendor"
    node_notifier_vendor_dir.rmtree # remove vendored pre-built binaries

    if OS.mac?
      terminal_notifier_dir = node_notifier_vendor_dir/"mac.noindex"
      terminal_notifier_dir.mkpath

      # replace vendored `terminal-notifier` with our own
      terminal_notifier_app = Formula["terminal-notifier"].opt_prefix/"terminal-notifier.app"
      ln_sf terminal_notifier_app.relative_path_from(terminal_notifier_dir), terminal_notifier_dir
    end

    # Replace universal binaries with their native slices
    deuniversalize_machos libexec/"lib/node_modules/sql-language-server/node_modules/fsevents/fsevents.node"
  end

  test do
    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    Open3.popen3("#{bin}/sql-language-server", "up", "--method", "stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
