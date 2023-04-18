class Plantuml < Formula
  desc "Draw UML diagrams"
  homepage "https://plantuml.com/"
  url "https://github.com/plantuml/plantuml/releases/download/v1.2023.6/plantuml-1.2023.6.jar"
  sha256 "bf2dee10750fd1794ad9eac7de020064d113838ec169448a16b639dbfb67617d"
  license "GPL-3.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42de574dda32286501b594587ddc9f509d87154681579f8589704cef0b6fcea9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42de574dda32286501b594587ddc9f509d87154681579f8589704cef0b6fcea9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42de574dda32286501b594587ddc9f509d87154681579f8589704cef0b6fcea9"
    sha256 cellar: :any_skip_relocation, ventura:        "42de574dda32286501b594587ddc9f509d87154681579f8589704cef0b6fcea9"
    sha256 cellar: :any_skip_relocation, monterey:       "42de574dda32286501b594587ddc9f509d87154681579f8589704cef0b6fcea9"
    sha256 cellar: :any_skip_relocation, big_sur:        "42de574dda32286501b594587ddc9f509d87154681579f8589704cef0b6fcea9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afc9ad2e30c6c62241a419e814f38fc9b24511d7bd9ce6b943dec941fb3c63f7"
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
