class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.49.1.tar.gz"
  sha256 "6ce8fc454e0e9ed3a29ca482129fa87704d26896b10cf2e75d51135f6edd573a"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0cd50407fe2f37731b81351654b8afc9dc153255a76578ab876cf47acf91d0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6e838c9500323d633e496fe659b75b8b1ce88ade91f11a1f0055ac5de03f7c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ce1baeac39dcf43202b798aa4310de6c15aab25596f09e9a309258902005e11"
    sha256 cellar: :any_skip_relocation, ventura:        "22546a13f172a2b0d595edf6a35f08af7b7ee6398987138a4e7368db183b63d0"
    sha256 cellar: :any_skip_relocation, monterey:       "248f0691f427df19b448f89afe816caa540b8396ae8185ae46b80aa9a90ad29c"
    sha256 cellar: :any_skip_relocation, big_sur:        "665481153e9f0a55ba71cffc0634fccfb55284f7f516392b13e62a742a41b830"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67dc20011f59e1ffd4e6ff19c0872fc6958a46b07db36b79b8e22bb85143d19b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/opa/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", "completion")
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
