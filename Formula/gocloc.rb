class Gocloc < Formula
  desc "Little fast LoC counter"
  homepage "https://github.com/hhatto/gocloc"
  url "https://github.com/hhatto/gocloc/archive/v0.4.1.tar.gz"
  sha256 "528be5009996b4177936be508aa494c289adddf58e4694b1a36067bda433f783"
  license "MIT"
  head "https://github.com/hhatto/gocloc.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "518e718b3cfe49ee519352ad5891868ad1445f83061ac1b93e89ab045060b6a5"
    sha256 cellar: :any_skip_relocation, big_sur:       "72eadebf1e8cafb5e94238f673af68216fbaacaae0100bfcb3699a6ffb54b9f3"
    sha256 cellar: :any_skip_relocation, catalina:      "a6dc5fa859f29d07e0668c169dfc4d240dbd46a8e79fbc63c31261cdf4f6a79b"
    sha256 cellar: :any_skip_relocation, mojave:        "a6dc5fa859f29d07e0668c169dfc4d240dbd46a8e79fbc63c31261cdf4f6a79b"
    sha256 cellar: :any_skip_relocation, high_sierra:   "a6dc5fa859f29d07e0668c169dfc4d240dbd46a8e79fbc63c31261cdf4f6a79b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/gocloc"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main(void) {
        return 0;
      }
    EOS

    assert_equal "{\"languages\":[{\"name\":\"C\",\"files\":1,\"code\":4,\"comment\":0," \
                 "\"blank\":0}],\"total\":{\"files\":1,\"code\":4,\"comment\":0,\"blank\":0}}",
                 shell_output("#{bin}/gocloc --output-type=json .")
  end
end
