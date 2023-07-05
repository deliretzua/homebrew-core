class Dscanner < Formula
  desc "Analyses e.g. the style and syntax of D code"
  homepage "https://github.com/dlang-community/D-Scanner"
  url "https://github.com/dlang-community/D-Scanner.git",
      tag:      "v0.15.2",
      revision: "1201a68f662a300eacae4f908a87d4cd57f2032e"
  license "BSL-1.0"
  head "https://github.com/dlang-community/D-Scanner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4859c5a899702bec8b2e529a658df33c4753e291661ac3ac5ae10f97ae570c53"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b87d68e91e9450a2b2fafd051ad2928750f76aaed96a33c734f881658d1ce343"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d9ac2f2c3dd601f634aa3e346b4f915c89b100fc2599aa3067e20bdba209c1f"
    sha256 cellar: :any_skip_relocation, ventura:        "d1a223d1bb4ad2ee8efb859225190a26dcf4f337ded8267369950794eb78b443"
    sha256 cellar: :any_skip_relocation, monterey:       "5b2d4dd7320c59fc87846a54279fd5600ef38551f9fe1ec1fbedfb6dc4cb782c"
    sha256 cellar: :any_skip_relocation, big_sur:        "66bcc4f5b3a0fb8a4a7816a400e71e08be559133502b57626c28f6d4a34766a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e374516d88766b4073fb17a78eb0ca48c105698e5061376f9ff2bbcf6a9ca21"
  end

  on_arm do
    depends_on "ldc" => :build
  end

  on_intel do
    depends_on "dmd" => :build
  end

  def install
    # Fix for /usr/bin/ld: obj/dmd/containers/src/containers/ttree.o:
    # relocation R_X86_64_32 against hidden symbol `__stop_minfo'
    # can not be used when making a PIE object
    ENV.append "DFLAGS", "-fPIC" if OS.linux?
    system "make", "all", "DC=#{Hardware::CPU.arm? ? "ldc2" : "dmd"}"
    bin.install "bin/dscanner"
  end

  test do
    (testpath/"test.d").write <<~EOS
      import std.stdio;
      void main(string[] args)
      {
        writeln("Hello World");
      }
    EOS

    assert_match(/test.d:\t28\ntotal:\t28\n/, shell_output("#{bin}/dscanner --tokenCount test.d"))
  end
end
