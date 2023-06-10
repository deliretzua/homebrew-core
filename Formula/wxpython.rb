class Wxpython < Formula
  desc "Python bindings for wxWidgets"
  homepage "https://www.wxpython.org/"
  url "https://files.pythonhosted.org/packages/aa/64/d749e767a8ce7bdc3d533334e03bb1106fc4e4803d16f931fada9007ee13/wxPython-4.2.1.tar.gz"
  sha256 "e48de211a6606bf072ec3fa778771d6b746c00b7f4b970eb58728ddf56d13d5c"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_ventura:  "9cf04be9fe96667a6243e0b6e0b9c34f1f15e86f83e817bd7d3d7dbec997e9b5"
    sha256 cellar: :any, arm64_monterey: "1999911bf51dd73f60c0adc99a3278fa573152a1535de68ef9553cc478ee5a66"
    sha256 cellar: :any, arm64_big_sur:  "fc912d301dc9e189cb9415d0401213e23ce43752dbe1eef499a02cd4154e3334"
    sha256 cellar: :any, ventura:        "4f8b6ad5e9a3645c207d07b2c8b67fba06cc830932a8503c9cfefc76120ddd28"
    sha256 cellar: :any, monterey:       "2fa4ada01a2f338678543fbac2f1acd148b257aa84a9735914f27d9a8a4fea7b"
    sha256 cellar: :any, big_sur:        "981eb95dcd1bc38c7f2a1999858c729b9ceef686f3e066c234bb11312640b115"
    sha256               x86_64_linux:   "5e3bfb9bd3e427fbd65d5b0e565aa7ee6f31c2eab1e3447a0c4b813b664a3d7a"
  end

  # FIXME: Build is currently broken with Doxygen 1.9.7+.
  # FIXME: depends_on "doxygen" => :build
  depends_on "bison" => :build # for `doxygen` resource
  depends_on "cmake" => :build # for `doxygen` resource
  depends_on "sip" => :build
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.11"
  depends_on "six"
  depends_on "wxwidgets"
  uses_from_macos "flex" => :build, since: :big_sur # for `doxygen` resource

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "gtk+3"
  end

  # Build is broken with Doxygen 1.9.7+.
  # TODO: Try to use Homebrew `doxygen` at next release.
  resource "doxygen" do
    url "https://doxygen.nl/files/doxygen-1.9.6.src.tar.gz"
    mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.9.6/doxygen-1.9.6.src.tar.gz"
    sha256 "297f8ba484265ed3ebd3ff3fe7734eb349a77e4f95c8be52ed9977f51dea49df"
  end

  def python
    "python3.11"
  end

  def install
    odie "Check if `doxygen` resource can be removed!" if build.bottle? && version > "4.2.1"
    # TODO: Try removing the block below at the next release.
    resource("doxygen").stage do
      system "cmake", "-S", ".", "-B", "build",
                      "-DPYTHON_EXECUTABLE=#{which(python)}",
                      *std_cmake_args(install_prefix: buildpath/".brew_home")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    ENV["DOXYGEN"] = buildpath/".brew_home/bin/doxygen" # Formula["doxygen"].opt_bin/"doxygen"
    system python, "-u", "build.py", "dox", "touch", "etg", "sip", "build_py",
                   "--release",
                   "--use_syswx",
                   "--prefix=#{prefix}",
                   "--jobs=#{ENV.make_jobs}",
                   "--verbose",
                   "--nodoc"
    system python, *Language::Python.setup_install_args(prefix, python),
                   "--skip-build",
                   "--install-platlib=#{prefix/Language::Python.site_packages(python)}"
  end

  test do
    output = shell_output("#{python} -c 'import wx ; print(wx.__version__)'")
    assert_match version.to_s, output
  end
end
