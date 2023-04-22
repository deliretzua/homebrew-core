class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/refs/tags/jql-v6.0.4.tar.gz"
  sha256 "daf2e6e8343ad7eca2b0cc430ae08c8e970f9277a8eb62e06a9781ec4d057216"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe367c186d398be701412a19c2dd3495aeaff4d0f9236ddeca0d18df8bd9514d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd3659394363892d6d2a86304369d21542d9b02c7f70fc2f8a6c33a9545e9901"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b41cc2a5da87f8718d33b60ab982533026981bc433099ebcd5a148940eb2ef9"
    sha256 cellar: :any_skip_relocation, ventura:        "232ef2bea846d834ea71ff5506cc0d98cf13187af7efdcdca9576e034c311d2b"
    sha256 cellar: :any_skip_relocation, monterey:       "84d6dbfc8f6838b96890642e589288b9b30ffefe19f5450be39d432b5b1e7465"
    sha256 cellar: :any_skip_relocation, big_sur:        "2508bb2e69c0a1364121e2b8f7261f050d2ae707b8be9ede9d2b426ce29cfcdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c78db56eb318e256abf7558f5a84702b2a179695cd2ac148c1b90bcf60ea84a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/jql")
  end

  test do
    (testpath/"example.json").write <<~EOS
      {
        "cats": [{ "first": "Pixie" }, { "second": "Kitkat" }, { "third": "Misty" }]
      }
    EOS
    output = shell_output("#{bin}/jql --inline --raw-string '\"cats\" [2:1] [0]' example.json")
    assert_equal '{"third":"Misty"}', output.chomp
  end
end
