require "language/node"

class AnsibleLanguageServer < Formula
  desc "Language Server for Ansible Files"
  homepage "https://github.com/ansible/ansible-language-server"
  url "https://registry.npmjs.org/@ansible/ansible-language-server/-/ansible-language-server-0.7.0.tgz"
  sha256 "3d013e314054ccbb4821493c63de194c188018ed7f279b687e463709ebf0ee61"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4b7336d1f71e49e1b42ef63e2f09a79d944b98d8c68f7a3eab7dc179d256e8a5"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
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

    Open3.popen3("#{bin}/ansible-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
