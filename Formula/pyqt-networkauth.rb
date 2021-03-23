class PyqtNetworkauth < Formula
  desc "Python bindings for The Qt Company’s Qt Network Authorization library"
  homepage "https://www.riverbankcomputing.com/software/pyqtnetworkauth"
  url "https://files.pythonhosted.org/packages/21/de/a7c4ef992a66be7ee458ab25ad7cdf93483712517ba807a74c30dc7c9375/PyQt6_NetworkAuth-6.0.3.tar.gz"
  sha256 "ae3c1540e9504eea024ee4da13c6ead146f987aa5fe1942c8d7465ef631e8ba8"
  license "GPL-3.0-only"

  bottle do
    sha256 arm64_big_sur: "e030e90dcfebb133cf2b63e68c2e5d3ac5e02a6bf92556f0635a75ed58743875"
    sha256 big_sur:       "999d21309897cb785a202c58cc9d5a887265526218bdd996d214632b731b5706"
    sha256 catalina:      "030504e723d97a3dd04a919a6b540c73f44fec280718518080a1efda222c0bb9"
    sha256 mojave:        "95dfccb61e147d87c38cfe810ec56603ad2e105275c3d5d4eb181afef98c9a8c"
  end

  depends_on "pyqt-builder" => :build

  depends_on "pyqt"
  depends_on "python@3.9"
  depends_on "qt"
  depends_on "sip"

  def install
    pyqt = Formula["pyqt"]
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"

    open("pyproject.toml", "a") do |f|
      f.puts "[tool.sip.project]"
      f.puts "sip-include-dirs = [\"#{pyqt.opt_lib}/python#{xy}/site-packages/PyQt#{pyqt.version.major}/bindings\"]"
    end

    system "sip-install", "--target-dir", prefix
    (lib/"python#{xy}/site-packages").install %W[#{prefix}/PyQt#{pyqt.version.major} #{prefix}/PyQt#{pyqt.version.major}_NetworkAuth-#{version}.dist-info]
  end

  test do
    pyqt = Formula["pyqt"]
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import PyQt#{pyqt.version.major}.QtNetworkAuth"
  end
end
