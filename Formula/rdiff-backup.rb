class RdiffBackup < Formula
  desc "Reverse differential backup tool, over a network or locally"
  homepage "https://rdiff-backup.net/"
  url "https://files.pythonhosted.org/packages/29/57/2722bf1fd732fed762f3307454df1175314f547ab0f069e2d4bc831d8d40/rdiff-backup-2.2.5.tar.gz"
  sha256 "86e2826b784ec3ea4ef187d936ee5f15277422c4077efa0156ef67e3139ea08e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5c83d4d892e3375b61cf26823d09ceba1f9c50042cc1b9169b5e229bf03642ed"
    sha256 cellar: :any,                 arm64_monterey: "61f5b82186deb11cd4f07a5d0330447cd7ea60c465ca3d87e54b6b8ad683d227"
    sha256 cellar: :any,                 arm64_big_sur:  "99569c1cf1be6fea5a974812ec2b4286fa0e2cbed4c670f3103ea4a8652d50c3"
    sha256 cellar: :any,                 ventura:        "979c5a9f23e1709f9de926b479731b0baf6f093ec0c13d7a7fdf64468407b034"
    sha256 cellar: :any,                 monterey:       "46007f5c710314f638f7f38025e7ec93a2060d661a392ce6ca17ed907915c114"
    sha256 cellar: :any,                 big_sur:        "7aa77a02ac4bd702384aee0fdce0ef1efe2ce2daf2113ccfeab8232fe994167f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0124759c951f6a29bbb06e61afb769780f4b435d0ff80585b196db3ba6abfc8c"
  end

  depends_on "librsync"
  depends_on "python@3.11"
  depends_on "pyyaml"

  def install
    python3 = "python3.11"
    system python3, *Language::Python.setup_install_args(prefix, python3), "--install-data=#{prefix}"
  end

  test do
    system "#{bin}/rdiff-backup", "--version"
  end
end
