class Fblog < Formula
  desc "Small command-line JSON log viewer"
  homepage "https://github.com/brocode/fblog"
  url "https://github.com/brocode/fblog/archive/v4.2.0.tar.gz"
  sha256 "de7e7e012301eec9df891a4bbc27088e43a7fdbf8066532fc35e85a38edde5f1"
  license "WTFPL"
  head "https://github.com/brocode/fblog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17e1b133c20a8a62777b6e366907f443fd8e1269e76fbda0bf98e5f33dce35ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0f9ee74f1dfd000dc87288b710daff902f74b99b4c4950a328ea224038a219f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56ea04b6c2558189bf365503bc0127e627454b4e6f35540cd1cde40d0cfc03da"
    sha256 cellar: :any_skip_relocation, monterey:       "bfa0031a2a0baf63d92f6824fea68ee21fe3a74aa5a3f3762eead8d7322a4c3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "4393a79903a37c114cbebbb3fe95d7a664963cb3049d9ce64e7b8c1af747ae98"
    sha256 cellar: :any_skip_relocation, catalina:       "058b79cbfa7a9ff319fa6224a8fd905ca584f19127a56603191c950df255e8fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9507c792400d7a3715bc7eec7a1f3dff2f70cbaea577a91dab64e1dfb8e5557d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Install a sample log for testing purposes
    pkgshare.install "sample.json.log"
  end

  test do
    output = shell_output("#{bin}/fblog #{pkgshare/"sample.json.log"}")

    assert_match "Trust key rsa-43fe6c3d-6242-11e7-8b0c-02420a000007 found in cache", output
    assert_match "Content-Type set both in header", output
    assert_match "Request: Success", output
  end
end
