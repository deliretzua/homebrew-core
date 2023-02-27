class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/swsnr/mdcat"
  url "https://github.com/swsnr/mdcat/archive/refs/tags/mdcat-1.1.0.tar.gz"
  sha256 "dff426fca44fd014b45fd5707f88f6f49a857f3806cf7793cfbc586058221d0a"
  license "MPL-2.0"
  head "https://github.com/swsnr/mdcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea738103ffed223640f43d1c714e64e504ae8e7fa79b11d8206fcd6f82230b85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "799fa267fc1eb1f4a2ff33f38a26c81d683b5a92da70d0d7a258880ea41f5522"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e939e444069656113d36806995586ec40745a8ef4c403221eed407ce5c4312c"
    sha256 cellar: :any_skip_relocation, ventura:        "9be246d38a1a2e32ad57d83153ef8dffa4b8a96258dc4758495ace4c13ff1191"
    sha256 cellar: :any_skip_relocation, monterey:       "4ef7480b61fedf8afb0a03217064bcd45d2b1c598eaf80ad54bd72e5ca082ac1"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7d9ec7e2c75a9a7bf7b9ccaf34f85c55e27f714fe12d229ee6e7d1801afefcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3f37306252be01f090bf9693d57ec5dacdae3be32dc1e5ab0462cdc699efeda"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
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
