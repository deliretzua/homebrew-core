class Duply < Formula
  desc "Frontend to the duplicity backup system"
  # Canonical domain: duply.net
  # Historical homepage: https://web.archive.org/web/20131126005707/ftplicity.sourceforge.net
  homepage "https://sourceforge.net/projects/ftplicity/"
  url "https://downloads.sourceforge.net/project/ftplicity/duply%20%28simple%20duplicity%29/2.4.x/duply_2.4.3.tgz"
  sha256 "867388531ddda2a5cdb0a2af77bde03261491c03a406b60fe26b96b4d92627a3"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/duply[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99efd54fd27cfb551827ad05b58d04d460aee5960aeff466cbd5fc37094d647f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99efd54fd27cfb551827ad05b58d04d460aee5960aeff466cbd5fc37094d647f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99efd54fd27cfb551827ad05b58d04d460aee5960aeff466cbd5fc37094d647f"
    sha256 cellar: :any_skip_relocation, ventura:        "0ecce4951b246981906b48a9ba3fca961dffcf0c581d1603facad3928dee218c"
    sha256 cellar: :any_skip_relocation, monterey:       "0ecce4951b246981906b48a9ba3fca961dffcf0c581d1603facad3928dee218c"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ecce4951b246981906b48a9ba3fca961dffcf0c581d1603facad3928dee218c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99efd54fd27cfb551827ad05b58d04d460aee5960aeff466cbd5fc37094d647f"
  end

  depends_on "duplicity"

  def install
    bin.install "duply"
  end

  test do
    system "#{bin}/duply", "-v"
  end
end
