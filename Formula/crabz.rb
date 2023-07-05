class Crabz < Formula
  desc "Like pigz, but in Rust"
  homepage "https://github.com/sstadick/crabz"
  url "https://github.com/sstadick/crabz/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "41efe343480587a44bb6e050f91e50e2318366cca5fb91d22ff7022ca5320a3b"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/sstadick/crabz.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    test_data = "a" * 1000
    (testpath/"example").write test_data
    system bin/"crabz", "-f", "gzip", testpath/"example", "-o", testpath/"example.gz"
    assert_predicate testpath/"example.gz", :exist?
    system bin/"crabz", "-d", testpath/"example.gz", "-o", testpath/"example2"
    assert_equal test_data, (testpath/"example2").read

    assert_match "crabz cargo:#{version}", shell_output("#{bin}/crabz --version")
  end
end
