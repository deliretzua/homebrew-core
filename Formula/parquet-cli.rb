class ParquetCli < Formula
  desc "Apache Parquet command-line tools and utilities"
  homepage "https://parquet.apache.org/"
  url "https://github.com/apache/parquet-mr.git",
      tag:      "apache-parquet-1.13.0",
      revision: "2e369ed173f66f057c296e63c1bc31d77f294f41"
  license "Apache-2.0"
  head "https://github.com/apache/parquet-mr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a411057efdb1d471ba0f7da8c4c81ec3bd32cb9f68b51dfceec5dd67d1f3adf7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "feb0ac58cc6e7cebfb4c8f999bebe8821fb53e6d48a5674f0cb541c6c1f88608"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4738900ccf09ed266e176b4bf5984c61c5c083bf4547c13d7caf403ae6146d4"
    sha256 cellar: :any_skip_relocation, ventura:        "802880c473564959939d9e3c9ee5983fb9cf0f68fc5c8788796946c04fdd819d"
    sha256 cellar: :any_skip_relocation, monterey:       "37c3f5ba078794608d2b1402cfdef42414b16151636ace59b2b52a5160df1a68"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce0a8a0b97818bda0f82a331dde7dbbfa8f5cd2e5143fa8514a494ab217b5e91"
    sha256 cellar: :any_skip_relocation, catalina:       "18105bc4181c1a29479b9b62ec8d884f0e9f9425bbb6b30606bb8dea9b7fdd61"
  end

  depends_on "maven" => :build

  # parquet-cli has problems running on Linux, for more information:
  # https://github.com/Homebrew/homebrew-core/pull/94318#issuecomment-1049229342
  depends_on :macos

  depends_on "openjdk"

  # This file generated with `red-parquet` gem:
  #   Arrow::Table.new("values" => ["foo", "Homebrew", "bar"]).save("homebrew.parquet")
  resource("test-parquet") do
    url "https://gist.github.com/bayandin/2144b5fc6052153c1a33fd2679d50d95/raw/7d793910a1afd75ee4677f8c327491f7bdd2256b/homebrew.parquet"
    sha256 "5caf572cb0df5ce9d6893609de82d2369b42c3c81c611847b6f921d912040118"
  end

  def install
    cd "parquet-cli" do
      system "mvn", "clean", "package", "-DskipTests=true"
      system "mvn", "dependency:copy-dependencies"
      libexec.install "target/parquet-cli-#{version}-runtime.jar"
      libexec.install Dir["target/dependency/*"]
      (bin/"parquet").write <<~EOS
        #!/bin/sh
        set -e
        exec "#{Formula["openjdk"].opt_bin}/java" -cp "#{libexec}/*" org.apache.parquet.cli.Main "$@"
      EOS
    end
  end

  test do
    resource("test-parquet").stage testpath

    output = shell_output("#{bin}/parquet cat #{testpath}/homebrew.parquet")
    assert_match "{\"values\": \"Homebrew\"}", output
  end
end
