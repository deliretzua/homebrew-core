class Geoserver < Formula
  desc "Java server to share and edit geospatial data"
  homepage "https://geoserver.org/"
  url "https://downloads.sourceforge.net/project/geoserver/GeoServer/2.23.2/geoserver-2.23.2-bin.zip"
  sha256 "e333ad71459e6ffcee6c4637c0d09805e4ad45281ad9b9b506705afaa732782c"
  license "GPL-2.0-or-later"

  # GeoServer releases contain a large number of files for each version, so the
  # SourceForge RSS feed may only contain the most recent version (which may
  # have a different major/minor version than the latest stable). We check the
  # "GeoServer" directory page instead, since this is reliable.
  livecheck do
    url "https://sourceforge.net/projects/geoserver/files/GeoServer/"
    regex(%r{href=(?:["']|.*?GeoServer/)?v?(\d+(?:\.\d+)+)/?["' >]}i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d2d28fa20b54c57f70369fcce0399f32ac6af8858adc4f45e08afc2f66be2c30"
  end

  def install
    libexec.install Dir["*"]
    (bin/"geoserver").write <<~EOS
      #!/bin/sh
      if [ -z "$1" ]; then
        echo "Usage: $ geoserver path/to/data/dir"
      else
        cd "#{libexec}" && java -DGEOSERVER_DATA_DIR=$1 -jar start.jar
      fi
    EOS
  end

  def caveats
    <<~EOS
      To start geoserver:
        geoserver path/to/data/dir
    EOS
  end

  test do
    assert_match "geoserver path", shell_output("#{bin}/geoserver")
  end
end
