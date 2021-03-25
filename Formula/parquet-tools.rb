class ParquetTools < Formula
  desc "Apache Parquet command-line tools and utilities"
  homepage "https://parquet.apache.org/"
  url "https://github.com/apache/parquet-mr.git",
      tag:      "apache-parquet-1.12.0",
      revision: "db75a6815f2ba1d1ee89d1a90aeb296f1f3a8f20"
  license "Apache-2.0"
  head "https://github.com/apache/parquet-mr.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d9b85d31e4b7d62fe66178eb6e1c16f1ef21672cdefee382492eee1a30cc5934"
    sha256 cellar: :any_skip_relocation, big_sur:       "1c92af57c5d3e5df830feb8143737a6bddbe986169a80b6457fbd725c7509d06"
    sha256 cellar: :any_skip_relocation, catalina:      "9a8d696b41cd9b0c06a79aefeab6f1c8dd3124dec409390563adc2a2976e3a9b"
    sha256 cellar: :any_skip_relocation, mojave:        "90f8b4dc30bb841afe9a1e1654d95a4e7fe6fd3338196ea7c82e503c8a88b1d8"
    sha256 cellar: :any_skip_relocation, high_sierra:   "3fba4dc621d0ddb6e8cb648dba43398d98e37e0f954130353f368b6f849e6f06"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  # This file generated with `red-parquet` gem:
  #   Arrow::Table.new("values" => ["foo", "Homebrew", "bar"]).save("homebrew.parquet")
  resource("test-parquet") do
    url "https://gist.github.com/bayandin/2144b5fc6052153c1a33fd2679d50d95/raw/7d793910a1afd75ee4677f8c327491f7bdd2256b/homebrew.parquet"
    sha256 "5caf572cb0df5ce9d6893609de82d2369b42c3c81c611847b6f921d912040118"
  end

  def install
    cd "parquet-tools-deprecated" do
      system "mvn", "clean", "package", "-Plocal", "-DskipTests=true"
      libexec.install "target/parquet-tools-deprecated-#{version}.jar"
      bin.write_jar_script libexec/"parquet-tools-deprecated-#{version}.jar", "parquet-tools"
    end
  end

  test do
    resource("test-parquet").stage testpath

    output = shell_output("#{bin}/parquet-tools cat #{testpath}/homebrew.parquet")
    assert_match "values = Homebrew", output
  end
end
