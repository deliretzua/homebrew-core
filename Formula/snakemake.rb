class Snakemake < Formula
  include Language::Python::Virtualenv

  desc "Pythonic workflow system"
  homepage "https://snakemake.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/af/aa/30796fcf30bec2e1c8d653174df0ac3ac1b99196a49f4e34b525ac671d90/snakemake-7.18.0.tar.gz"
  sha256 "14721e6826b40aa91b96deca8d9f710b874be399634cf101a6069d05afe65873"
  license "MIT"
  head "https://github.com/snakemake/snakemake.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2f8f48fa459dc5a7e07ae1f70d4004db44c0c9ad8b6c9dfafeb75a282ee9288"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1da98831125c5bb5332b242307e1ad1be7b4b05c0d54a533b17d0fbe5243baa"
    sha256 cellar: :any_skip_relocation, monterey:       "c6fa93bad40352bdd937f76fdc8a9c057ef234703ee6819fe729e3515ee1c896"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc345c79947ada731399ee1745ae89c9ca52150ef9c63c1d52ad19018d825603"
    sha256 cellar: :any_skip_relocation, catalina:       "35f2fd0f0623b02ff77392699c8bd395a0c44cd525aff217064f7544a436c737"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd8e219960798ed180470498f93f71f14b982b831b8ec4f864b08aaece63033d"
  end

  depends_on "cbc"
  depends_on "jsonschema"
  depends_on "libpython-tabulate"
  depends_on "python@3.10"
  depends_on "pyyaml"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cb/a4/7de7cd59e429bd0ee6521ba58a75adaec136d32f91a761b28a11d8088d44/certifi-2022.9.24.tar.gz"
    sha256 "0d9c601124e5a6ba9712dbc60d9c53c21e34f5f641fe83002317394311bdce14"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "ConfigArgParse" do
    url "https://files.pythonhosted.org/packages/16/05/385451bc8d20a3aa1d8934b32bd65847c100849ebba397dbf6c74566b237/ConfigArgParse-1.5.3.tar.gz"
    sha256 "1b0b3cbf664ab59dada57123c81eff3d9737e0d11d8cf79e3d6eb10823f1739f"
  end

  resource "connection_pool" do
    url "https://files.pythonhosted.org/packages/bd/df/c9b4e25dce00f6349fd28aadba7b6c3f7431cc8bd4308a158fbe57b6a22e/connection_pool-0.0.3.tar.gz"
    sha256 "bf429e7aef65921c69b4ed48f3d48d3eac1383b05d2df91884705842d974d0dc"
  end

  resource "datrie" do
    url "https://files.pythonhosted.org/packages/9d/fe/db74bd405d515f06657f11ad529878fd389576dca4812bea6f98d9b31574/datrie-0.8.2.tar.gz"
    sha256 "525b08f638d5cf6115df6ccd818e5a01298cd230b2dac91c8ff2e6499d18765d"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/6b/5c/330ea8d383eb2ce973df34d1239b3b21e91cd8c865d21ff82902d952f91f/docutils-0.19.tar.gz"
    sha256 "33995a6753c30b7f577febfc2c50411fec6aac7f7ffeb7c4cfe5991072dcf9e6"
  end

  resource "dpath" do
    url "https://files.pythonhosted.org/packages/a0/cf/cf35f8b7f212be18634970a5b2d7a50adc715e649a0a8fedb06c909603d8/dpath-2.0.6.tar.gz"
    sha256 "5a1ddae52233fbc8ef81b15fb85073a81126bb43698d3f3a1b6aaf561a46cdc0"
  end

  resource "fastjsonschema" do
    url "https://files.pythonhosted.org/packages/7a/62/6df03bacda3544b5872d0b30f79c599ab84fc598858c77a77e1587d61ba3/fastjsonschema-2.16.2.tar.gz"
    sha256 "01e366f25d9047816fe3d288cbfc3e10541daf0af2044763f3d0ade42476da18"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/fc/44/64e02ef96f20b347385f0e9c03098659cb5a1285d36c3d17c56e534d80cf/gitdb-4.0.9.tar.gz"
    sha256 "bac2fd45c0a1c9cf619e63a90d62bdc63892ef92387424b855792a6cabe789aa"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/22/ab/3dd8b8a24399cee9c903d5f7600d20e8703d48904020f46f7fa5ac5474e9/GitPython-3.1.29.tar.gz"
    sha256 "cc36bfc4a3f913e66805a28e84703e419d9c264c1077e537b54f0e1af85dbefd"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "jupyter-core" do
    url "https://files.pythonhosted.org/packages/95/74/96d10b3a8575123892c807f35a14bab969771d0c630b51d1208678b31d15/jupyter_core-4.11.2.tar.gz"
    sha256 "c2909b9bc7dca75560a6c5ae78c34fd305ede31cd864da3c0d0bb2ed89aa9337"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  resource "nbformat" do
    url "https://files.pythonhosted.org/packages/9c/54/5b39dfc6585e1dfc8c119252754c19dd85ee974606b73e3fa8a2242413d2/nbformat-5.7.0.tar.gz"
    sha256 "1d4760c15c1a04269ef5caf375be8b98dd2f696e5eb9e603ec2bf091f9b0d3f3"
  end

  resource "plac" do
    url "https://files.pythonhosted.org/packages/45/39/db67ba7731ab4461c1d365aac1df695712bb6b9629e56540789a36d5c3aa/plac-1.3.5.tar.gz"
    sha256 "38bdd864d0450fb748193aa817b9c458a8f5319fbf97b2261151cfc0a5812090"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/de/eb/1c01a34c86ee3b058c556e407ce5b07cb7d186ebe47b3e69d6f152ca5cc5/psutil-5.9.3.tar.gz"
    sha256 "7ccfcdfea4fc4b0a02ca2c31de7fcd186beb9cff8207800e14ab66f79c773af6"
  end

  resource "PuLP" do
    url "https://files.pythonhosted.org/packages/3a/74/0d6744ac87cbe9773be70917381d1834ac44015af7b6fa5cbc07b61abf03/PuLP-2.6.0.tar.gz"
    sha256 "4b4f7e1e954453e1b233720be23aea2f10ff068a835ac10c090a93d8e2eb2e8d"
  end

  resource "ratelimiter" do
    url "https://files.pythonhosted.org/packages/5b/e0/b36010bddcf91444ff51179c076e4a09c513674a56758d7cfea4f6520e29/ratelimiter-1.2.0.post0.tar.gz"
    sha256 "5c395dcabdbbde2e5178ef3f89b568a3066454a6ddc223b76473dac22f89b4f7"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "reretry" do
    url "https://files.pythonhosted.org/packages/d3/75/4e53865926a372de99299c2fb1f00d508c33e00d9a32e9dacaf8a4001861/reretry-0.11.1.tar.gz"
    sha256 "4ae1840ae9e443822bb70543c485bb9c45d1d009e32bd6809f2a9f2839149f5d"
  end

  resource "smart-open" do
    url "https://files.pythonhosted.org/packages/62/d8/c25a41a4a652984706b1e3529ebb1150c07dd1d7c69892f8a6d5ac1b792c/smart_open-6.2.0.tar.gz"
    sha256 "1b4df5c8365218f3852c507451920ccad606c80b0acb4e67508e50ba9b5d2632"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
  end

  resource "stopit" do
    url "https://files.pythonhosted.org/packages/35/58/e8bb0b0fb05baf07bbac1450c447d753da65f9701f551dca79823ce15d50/stopit-1.1.2.tar.gz"
    sha256 "f7f39c583fd92027bd9d06127b259aee7a5b7945c1f1fa56263811e1e766996d"
  end

  resource "toposort" do
    url "https://files.pythonhosted.org/packages/b2/be/67bec9a73041616dd359f06e997d56c9c99d252460a3f035411d97c96c48/toposort-1.7.tar.gz"
    sha256 "ddc2182c42912a440511bd7ff5d3e6a1cabc3accbc674a3258c8c41cbfbb2125"
  end

  resource "traitlets" do
    url "https://files.pythonhosted.org/packages/dd/a8/278742d17c9e95ccb0dcb86ae216df114d2166d88e72f42b60a7b58b600b/traitlets-5.5.0.tar.gz"
    sha256 "b122f9ff2f2f6c1709dab289a05555be011c87828e911c0cf4074b85cb780a79"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/11/eb/e06e77394d6cf09977d92bff310cb0392930c08a338f99af6066a5a98f92/wrapt-1.14.1.tar.gz"
    sha256 "380a85cf89e0e69b7cfbe2ea9f765f004ff419f34194018a6827ac0e3edfed4d"
  end

  resource "yte" do
    url "https://files.pythonhosted.org/packages/bd/ec/85b6f67edccf6789bd5feeabe8906f5626e9328c9b340008ac0378668c59/yte-1.5.1.tar.gz"
    sha256 "6d0b315b78af83276d78f5f67c107c84238f772a76d74f4fc77905b46f3731f5"
  end

  def install
    virtualenv_install_with_resources

    # we depend on jsonschema, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.10")
    jsonschema = Formula["jsonschema"].opt_libexec
    (libexec/site_packages/"homebrew-jsonschema.pth").write jsonschema/site_packages
  end

  test do
    (testpath/"Snakefile").write <<~EOS
      rule testme:
          output:
               "test.out"
          shell:
               "touch {output}"
    EOS
    test_output = shell_output("#{bin}/snakemake --cores 1 -s #{testpath}/Snakefile 2>&1")
    assert_predicate testpath/"test.out", :exist?
    assert_match "Building DAG of jobs...", test_output
  end
end
