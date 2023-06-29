class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20230628.tar.gz"
  sha256 "86876a745e3d224dcfd222ed3de465b47559e85811df2db9820ef09a9dff5cce"
  license any_of: ["Intel-ACPI", "GPL-2.0-only", "BSD-3-Clause"]
  head "https://github.com/acpica/acpica.git", branch: "master"

  livecheck do
    url "https://acpica.org/downloads"
    regex(/href=.*?acpica-unix[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d5bc81ae6d21be9bb492c4cedf64201bc80eb3b7cecb6f91010dcb4bb8aaeb28"
    sha256 cellar: :any_skip_relocation, ventura:       "f40092e1689e86fe1fd20e28f5741d17bbad91cc1ad8a03b96d9ef9b5d58c51f"
    sha256 cellar: :any_skip_relocation, monterey:      "2044755952b25d661d7dc0a64aafd4a20dab29898634a6e74a0b406bea1764e0"
    sha256 cellar: :any_skip_relocation, big_sur:       "b67a340c0036a142b176feb0c1010a20e561913b60c5030b3dc4ea90d4783c94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fdbe69af80a2c8b1289ecc7cbd868cc35511ff64836333bd7b30f680367cca6"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "m4" => :build

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/acpihelp", "-u"
  end
end
