class PipeRename < Formula
  desc "Rename your files using your favorite text editor"
  homepage "https://github.com/marcusbuffett/pipe-rename"
  url "https://crates.io/api/v1/crates/pipe-rename/1.6.3/download"
  sha256 "7f69604f7a1f7fa9914aeef8491ee2281b8b1e3fab2eaf4f63c1e5d57e37d654"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56ca6d3b6d0d4d330139d570fb5901028009766f52902940a4f6144f239c025c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b562db0f8fb048887791a7eb3a2fa5b3aa6469eabeb5e2d54eb7cbc0b50296c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bdcd06c954d87dd5cf2875593352fcc1d89b324e237d3143e2d864ba5f6a80a7"
    sha256 cellar: :any_skip_relocation, ventura:        "44250ca40ef1dbaa211fd04936107d9a972d42528472d9a33edab2b0e1194941"
    sha256 cellar: :any_skip_relocation, monterey:       "8fcea68e19e57b89c1915e1172a15a95f8bc6a9391b2999dfd93914333670c7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff62e780bd8b3a3b39d54c6b95e8474df8808b705ec13ded991917c26a6831b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6247fa7e8e5ee033eaa72e402ed23210a546c807414b19e9ad1116ba15879c9"
  end

  depends_on "rust" => :build

  def install
    system "tar", "xvf", "pipe-rename-#{version}.crate", "--strip-components=1"
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch "test.log"
    (testpath/"rename.sh").write "#!/bin/sh\necho \"$(cat \"$1\").txt\" > \"$1\""
    chmod "+x", testpath/"rename.sh"
    ENV["EDITOR"] = testpath/"rename.sh"
    system "#{bin}/renamer", "-y", "test.log"
    assert_predicate testpath/"test.log.txt", :exist?
  end
end
