class Plantuml < Formula
  desc "Draw UML diagrams"
  homepage "https://plantuml.com/"
  url "https://github.com/plantuml/plantuml/releases/download/v1.2023.9/plantuml-1.2023.9.jar"
  sha256 "dbc4fe71dd3d50792a4f631f0a6c7dee7644563cd3daf0a3da39c1f112c08bf0"
  license "GPL-3.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc6d8f807f0c5328d32a9a2bb777a463b7802d001400ae79d768c1dc3de816a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc6d8f807f0c5328d32a9a2bb777a463b7802d001400ae79d768c1dc3de816a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc6d8f807f0c5328d32a9a2bb777a463b7802d001400ae79d768c1dc3de816a2"
    sha256 cellar: :any_skip_relocation, ventura:        "dc6d8f807f0c5328d32a9a2bb777a463b7802d001400ae79d768c1dc3de816a2"
    sha256 cellar: :any_skip_relocation, monterey:       "dc6d8f807f0c5328d32a9a2bb777a463b7802d001400ae79d768c1dc3de816a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc6d8f807f0c5328d32a9a2bb777a463b7802d001400ae79d768c1dc3de816a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c58899f8702c0275b6d9705321408bf644a53ad3a9acbf01a6add9cba074c7a"
  end

  depends_on "graphviz"
  depends_on "openjdk"

  def install
    jar = "plantuml.jar"
    libexec.install "plantuml-#{version}.jar" => jar
    (bin/"plantuml").write <<~EOS
      #!/bin/bash
      if [[ "$*" != *"-gui"* ]]; then
        VMARGS="-Djava.awt.headless=true"
      fi
      GRAPHVIZ_DOT="#{Formula["graphviz"].opt_bin}/dot" exec "#{Formula["openjdk"].opt_bin}/java" $VMARGS -jar #{libexec}/#{jar} "$@"
    EOS
    chmod 0755, bin/"plantuml"
  end

  test do
    system bin/"plantuml", "-testdot"
  end
end
