class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/9e/4d/eb097ebdaec2944420c463eeae47fc20d3a27eecd677b5286f424b97de6a/translate-toolkit-3.10.0.tar.gz"
  sha256 "e3690caeef90dab491e6a8426c1d920aab265ef5f5bc7fe004a04e73560c4a3b"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5518fbf403a865cb3465094aea94f3f32b21ad37795c123c03b1156fc7c37d8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d775b18f181ea4c03225bb1f21c66edfe5b70b44a7514d6723b034e1d25b279d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4bd945ecba2965d7569a93f46114b87770a7b91f0d5c510389241a5a33a5e549"
    sha256 cellar: :any_skip_relocation, ventura:        "25abcfebdc151967803c1ff3d2187ea867a12949d96b54a6f65643460728c507"
    sha256 cellar: :any_skip_relocation, monterey:       "39f296bdffe523d16aa96f02f3941e43cce18a74dfd320074956cdca78d18aea"
    sha256 cellar: :any_skip_relocation, big_sur:        "59ea66a0716c74e54146647a2e6b9bb81b163f1afa802e3049129e7e34f10e5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d0239ac8ffe3121b5cc28fe05fa9d99f2ff6501cb77b76cb1e0d645ec4bd6d8"
  end

  depends_on "python@3.11"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/30/39/7305428d1c4f28282a4f5bdbef24e0f905d351f34cf351ceb131f5cddf78/lxml-4.9.3.tar.gz"
    sha256 "48628bd53a426c9eb9bc066a923acaa0878d1e86129fd5359aee99285f4eed9c"
  end

  def install
    # Workaround to avoid creating libexec/bin/__pycache__ which gets linked to bin
    ENV["PYTHONPYCACHEPREFIX"] = buildpath/"pycache"

    virtualenv_install_with_resources
  end

  test do
    system bin/"pretranslate", "-h"
    system bin/"podebug", "-h"
  end
end
