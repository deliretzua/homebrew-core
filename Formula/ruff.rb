class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.193.tar.gz"
  sha256 "ed29800ca1087ceeb046483ba8914c7441fc2b561d4e5ba71d57935b8b5268bb"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c21fdc5c95c633bcc5b48ee6884b61050ebb33035ac137533941d7f961f143f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51a5de2bd1afc4e39f8ae2101bb91fef3d71e4e830d30ff35439c94ecae8e464"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f43036def8de829497f95812ae6fff3857ae7b91b0072fa38ba746f74961771"
    sha256 cellar: :any_skip_relocation, ventura:        "818534828d1837dce71497014d2bf591735264669567e28ad331644a74eb21e2"
    sha256 cellar: :any_skip_relocation, monterey:       "2c803acb0853c2eed286d45578c22d998c63020823e7271563152ffe45940c4a"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a2fb486637c43715121a4fa0434ddef4bb8aa59292592f8b8cffce5e01d2e3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06f27896bb762942476e0680faae6308fbeb055df6b7daf705db754409c0723c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args
    bin.install "target/release/ruff" => "ruff"
    generate_completions_from_executable(bin/"ruff", ".", shell_parameter_format: "--generate-shell-completion=")
  end

  test do
    (testpath/"test.py").write <<~EOS
      import os
    EOS

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff --quiet #{testpath}/test.py", 1)
  end
end
