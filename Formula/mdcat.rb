class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/lunaryorn/mdcat"
  url "https://github.com/lunaryorn/mdcat/archive/mdcat-0.24.1.tar.gz"
  sha256 "f0e400f2060a460e347546932fcb501da71fab5af602413c7932fac35136b89f"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cdf9ad9ee87ee18d83029d1baa9cbb63c7317b3c0a9efa092782bb3e8b792e75"
    sha256 cellar: :any_skip_relocation, big_sur:       "df694ef2d2b10b2637ae41e2212a5314d073932483835731f3204979afd55aa7"
    sha256 cellar: :any_skip_relocation, catalina:      "76a53e35a66a2e1e78d36ad7e53dc1f3b595c17e361c953dc23818f9f9ca6079"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c53dd8252ff09b44cfb8cf3134cb34159ed8e70aa1a5160088352ee090405450"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.md").write <<~EOS
      _lorem_ **ipsum** dolor **sit** _amet_
    EOS
    output = shell_output("#{bin}/mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end
