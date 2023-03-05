class Jags < Formula
  desc "Just Another Gibbs Sampler for Bayesian MCMC simulation"
  homepage "https://mcmc-jags.sourceforge.io"
  url "https://downloads.sourceforge.net/project/mcmc-jags/JAGS/4.x/Source/JAGS-4.3.2.tar.gz"
  sha256 "871f556af403a7c2ce6a0f02f15cf85a572763e093d26658ebac55c4ab472fc8"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/JAGS[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "19a6c1cc43790fdc7c79ca07194ee6b349fd39de66cbc91fa9c56572e791dad5"
    sha256 cellar: :any,                 arm64_monterey: "5fe69bb218cbcd93a194c8bd610de71e9f4642ae0095307ce5eac01d8fcc9dc5"
    sha256 cellar: :any,                 arm64_big_sur:  "c9eeb588bbb9ab7e510cde300552d5600a4f4645f0a3659b6c6ae231b4cdd5cd"
    sha256 cellar: :any,                 ventura:        "a715c31c70722db36b832c40ef72c51e1d24007ef73c875a90babae90feefa3d"
    sha256 cellar: :any,                 monterey:       "e0e85fc93e1427ba170ffbd9a3b561880724cfd3db9e599d42de652bd2e7e48c"
    sha256 cellar: :any,                 big_sur:        "70d8dddaa0344b5e5f940bff4170a4af1075b403e48f3f7ef7f7fc69900d0cde"
    sha256 cellar: :any,                 catalina:       "73ae1d3288ea381653cffcb2ef30b67a90760df5f25361a42bf5dd7b13bbecce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5741f22fe71e0da0f999bf4a5a9059f7c66285474ee9c9dfd40d4dbc9bbd1482"
  end

  depends_on "gcc" # for gfortran

  on_linux do
    depends_on "openblas"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"model.bug").write <<~EOS
      data {
        obs <- 1
      }
      model {
        parameter ~ dunif(0,1)
        obs ~ dbern(parameter)
      }
    EOS
    (testpath/"script").write <<~EOS
      model in model.bug
      compile
      initialize
      monitor parameter
      update 100
      coda *
    EOS
    system "#{bin}/jags", "script"
  end
end
