class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.81.0.tar.gz"
  sha256 "c7e74827f4800df747097e0d6538e6cfc15011393ef57aef827589afb5f7d5a3"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fdf7836ea49b1b20a38c594a9c8cc72ac333d6af8bc9596499ad49ba45021ad1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ab835a4413a40aab2204aa51980616ea316fdcfad009a7a13b065d04b54c65d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79986adf1c84ec73fdb364b1ebe407bb51fbca1cd8e74a0b30af7014e486fd64"
    sha256 cellar: :any_skip_relocation, ventura:        "dc447407fef6a83b1a2ea7fc4d01a71bb3ca124b5583580b24978ffebb09af19"
    sha256 cellar: :any_skip_relocation, monterey:       "87488f3b03d1e0983bcd1654a4dba9972e73834ab0be5552342de09bb3747985"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3f0da099a64ac2f49f25d48586237878729c5590896ac18ec6cf0ee8a887e56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bb69c90bdd8d63105987d9e57b9e1c4c46546191bc5445c23a31682c2f113b2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args, "--features", "apply,full"
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    assert_equal <<~EOS, shell_output("#{bin}/qsv stats test.csv")
      field,type,sum,min,max,range,min_length,max_length,mean,stddev,variance,nullcount
      first header,NULL,,,,,,,,,,0
      second header,NULL,,,,,,,,,,0
    EOS
  end
end
