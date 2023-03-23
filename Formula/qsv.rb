class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.95.0.tar.gz"
  sha256 "1ca6f622921f89235d60e374d9929d4938597b8f81941d96e011c02b6dd63a56"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88e9b14c17b9cd86b793e9dec062ddc56a035c72d85688f979910fa5ff0fccd1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "733881f1b48bcbd850dd74a2e31839cd97991ce23be63797fc5cf11b3a5db366"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5d6aae89142e745c42dc6e3847aa2de210da7104315c62f2582181482d53119"
    sha256 cellar: :any_skip_relocation, ventura:        "83a3b8f244cfca2e7672be603e683171c48dc29391b91e1a9bc5a5fcc74dd660"
    sha256 cellar: :any_skip_relocation, monterey:       "b9abf313d5212686a9db4187513ce07576b09085a2f904af365344a070b69006"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f26524e80edf845235b3180b92c30f9adfb238817b687e90c8f1c03c1f4d7c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b204321bc0251e08bdb477b38a52b8da5009c1c170557ef99ce6911a53758e5e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args, "--features", "apply,luau,full"
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    assert_equal <<~EOS, shell_output("#{bin}/qsv stats test.csv")
      field,type,sum,min,max,range,min_length,max_length,mean,stddev,variance,nullcount,sparsity
      first header,NULL,,,,,,,,,,0,
      second header,NULL,,,,,,,,,,0,
    EOS
  end
end
