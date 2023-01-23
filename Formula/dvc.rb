class Dvc < Formula
  include Language::Python::Virtualenv

  desc "Git for data science projects"
  homepage "https://dvc.org"
  url "https://files.pythonhosted.org/packages/1b/4f/444fa88e9e1e0a58a2c6f5f055e74e5935502438f512e0bf5f978799cf66/dvc-2.43.0.tar.gz"
  sha256 "7a7a963b76e1733890e60a4b58242f6fe033f5ba1c9fbedcf9ff495512c3c7e9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9683c8cad7455d040ea024babd1ef50c287db5a19dbe3ed1e2982c988c6841b2"
    sha256 cellar: :any,                 arm64_monterey: "43017260e269985c27f4787c61769a4fd6e35ea099d714fffa218fe11df02d58"
    sha256 cellar: :any,                 arm64_big_sur:  "01721c456700822ea94271a619bd6b228d997c8ffb18f0cc068f3ad8174872ea"
    sha256 cellar: :any,                 ventura:        "5efdaa1102dfb7d98e3d7709daad9f36a7183ee36e2f033b6d15b758d146495d"
    sha256 cellar: :any,                 monterey:       "0d637b598c675f187651823db53e6cb815cd6cef6845303731a421843879a50d"
    sha256 cellar: :any,                 big_sur:        "a0c677f5f46a12bbb9e92b67229d9505023562e09d6c6ef7fe4058fde77c52f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "796721a7d83293fd147fede998980a4f479cee2cd0d045574b1859467adfff29"
  end

  depends_on "openjdk" => :build # for hydra-core
  depends_on "pkg-config" => :build
  depends_on "rust" => :build # for cryptography (required by azure deps)
  depends_on "apache-arrow"
  depends_on "libgit2"
  depends_on "numpy"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "pygments"
  depends_on "python-tabulate"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  # When updating, check that the extra packages in pypi_formula_mappings.json
  # correctly reflects the following extra packages in setup.py:
  # gs, s3, azure, oss, ssh, gdrive, webdav (hdfs is provided by apache-arrow)
  resource "adal" do
    url "https://files.pythonhosted.org/packages/90/d7/a829bc5e8ff28f82f9e2dc9b363f3b7b9c1194766d5a75105e3885bfa9a8/adal-1.2.7.tar.gz"
    sha256 "d74f45b81317454d96e982fd1c50e6fb5c99ac2223728aea8764433a39f566f1"
  end

  resource "adlfs" do
    url "https://files.pythonhosted.org/packages/06/d8/f6833ae98b86bb08b6b666330213574cebeeb84b969f4d03439ecd372a2f/adlfs-2023.1.0.tar.gz"
    sha256 "eca53f53d88fc8e2e7a2f1d8f5a40b8a1c56aa3b541e4aa2e7eaf55a6a789262"
  end

  resource "aiobotocore" do
    url "https://files.pythonhosted.org/packages/07/b0/2e289070e87af664253501d3c3d235fa17af6a380d6d01d5ca7219e83763/aiobotocore-2.4.2.tar.gz"
    sha256 "0603b74a582dffa7511ce7548d07dc9b10ec87bc5fb657eb0b34f9bd490958bf"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/ff/4f/62d9859b7d4e6dc32feda67815c5f5ab4421e6909e48cbc970b6a40d60b7/aiohttp-3.8.3.tar.gz"
    sha256 "3828fb41b7203176b82fe5d699e0d845435f2374750a44b480ea6b930f6be269"
  end

  resource "aiohttp-retry" do
    url "https://files.pythonhosted.org/packages/01/c1/d57818a0ed5b0313ad8c620638225ddd44094d0d606ee33f3df5105572cd/aiohttp_retry-2.8.3.tar.gz"
    sha256 "9a8e637e31682ad36e1ff9f8bcba912fcfc7d7041722bc901a4b948da4d71ea9"
  end

  resource "aioitertools" do
    url "https://files.pythonhosted.org/packages/4a/e6/888e1d726f0846c84e14a0f2f57873819eff9278b394d632aed979c98fbd/aioitertools-0.11.0.tar.gz"
    sha256 "42c68b8dd3a69c2bf7f2233bf7df4bb58b557bca5252ac02ed5187bbc67d6831"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/ae/67/0952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32f/aiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "aliyun-python-sdk-core" do
    url "https://files.pythonhosted.org/packages/55/5a/6eec6c6e78817e5ca2afee661f2bbb33dbcfa2ce09a2980b52223323bd2e/aliyun-python-sdk-core-2.13.36.tar.gz"
    sha256 "20bd54984fa316da700c7f355a51ab0b816690e2a0fcefb7b5ef013fed0da928"
  end

  resource "aliyun-python-sdk-kms" do
    url "https://files.pythonhosted.org/packages/d5/6f/648401212f41c91f8aeb7676d57c2840ed258cca64854a9315c2280b15df/aliyun-python-sdk-kms-2.16.0.tar.gz"
    sha256 "a7f185772c88f3a0dda856b666dda436d82e00f9f11ea5bbf12dcab2610ee358"
  end

  resource "amqp" do
    url "https://files.pythonhosted.org/packages/cb/e7/bcaab89065e17915a28247fa5d4f582ca107b4544e2b1aba92d32f794a0f/amqp-5.1.1.tar.gz"
    sha256 "2c1b13fecc0893e946c65cbd5f36427861cffa4ea2201d8f6fca22e2a373b5e2"
  end

  resource "antlr4-python3-runtime" do
    url "https://files.pythonhosted.org/packages/3e/38/7859ff46355f76f8d19459005ca000b6e7012f2f1ca597746cbcd1fbfe5e/antlr4-python3-runtime-4.9.3.tar.gz"
    sha256 "f224469b4168294902bb1efa80a8bf7855f24c99aef99cbefc1bcd3cce77881b"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/8b/94/6928d4345f2bc1beecbff03325cad43d320717f51ab74ab5a571324f4f5a/anyio-3.6.2.tar.gz"
    sha256 "25ea0d673ae30af41a0c442f81cf3b38c7e79fdc7b60335a4c14e05eb0947421"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/05/f8/67851ae4fe5396ba6868c5d84219b81ea6a5d53991a6853616095c30adc0/argcomplete-2.0.0.tar.gz"
    sha256 "6372ad78c89d662035101418ae253668445b391755cfe94ea52f1b9d22425b20"
  end

  resource "async-timeout" do
    url "https://files.pythonhosted.org/packages/54/6e/9678f7b2993537452710ffb1750c62d2c26df438aa621ad5fa9d1507a43a/async-timeout-4.0.2.tar.gz"
    sha256 "2163e1640ddb52b7a8c80d0a67a08587e5d245cc9c553a74a847056bc2976b15"
  end

  resource "asyncssh" do
    url "https://files.pythonhosted.org/packages/94/ca/90f4675fd5857c2a735694b6fe5d43c47102c605e7adb08785a4e28644d7/asyncssh-2.13.0.tar.gz"
    sha256 "be7e1cb47225dc9899e56472fdc4daac03584a6843675329c0ce67179cb20e29"
  end

  resource "atpublic" do
    url "https://files.pythonhosted.org/packages/8e/9a/ff8783e9e181ead59ae612a5df5bcd4f4bb3cc4147ef6aaa96f90020347b/atpublic-3.1.1.tar.gz"
    sha256 "3098ee12d0107cc5009d61f4e80e5edcfac4cda2bdaa04644af75827cb121b18"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/21/31/3f468da74c7de4fcf9b25591e682856389b3400b4b62f201e65f15ea3e07/attrs-22.2.0.tar.gz"
    sha256 "c9227bfc2f01993c03f68db37d1d15c9690188323c067c641f1a35ca58185f99"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/05/71/21dd6d5f227a5d82b869068a0b652b26edc9efb86c7a5139740a0ffeb775/azure-core-1.26.2.zip"
    sha256 "986bfd8687889782d79481d4c5d0af04ab4a18ca2f210364804a88e4eaa1586a"
  end

  resource "azure-datalake-store" do
    url "https://files.pythonhosted.org/packages/13/8b/2c151c9f4c3f5345d9a32889e15a471d98e426851b9fcf13dc9f134f5b93/azure-datalake-store-0.0.52.tar.gz"
    sha256 "4198ddb32614d16d4502b43d5c9739f81432b7e0e4d75d30e05149fe6007fea2"
  end

  resource "azure-identity" do
    url "https://files.pythonhosted.org/packages/fa/d7/a7402d68d1975d869ce3ba7b6e11983310c12ff8793f0ebf01cd7ca1f398/azure-identity-1.12.0.zip"
    sha256 "7f9b1ae7d97ea7af3f38dd09305e19ab81a1e16ab66ea186b6579d85c1ca2347"
  end

  resource "azure-storage-blob" do
    url "https://files.pythonhosted.org/packages/e8/72/a834f1a89f8b66e717d7cddc88ff182fb860130c4ff78f87a286eec602be/azure-storage-blob-12.14.1.zip"
    sha256 "860d4d82985a4bfc7d3271e71275af330f54f330a754355435a7ba749ccde997"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/8c/ae/3af7d006aacf513975fd1948a6b4d6f8b4a307f8a244e1a3d3774b297aad/bcrypt-4.0.1.tar.gz"
    sha256 "27d375903ac8261cfe4047f6709d16f7d18d39b1ec92aaf72af989552a650ebd"
  end

  resource "billiard" do
    url "https://files.pythonhosted.org/packages/92/91/40de1901da8ec9eeb7c6a22143ba5d55d8aaa790761ca31342cedcd5c793/billiard-3.6.4.0.tar.gz"
    sha256 "299de5a8da28a783d51b197d496bef4f1595dd023a93a4f59dde1886ae905547"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/3f/3b/eac5f57a495da702f34eb7c1f34a325d122c4e2f9ffd99bac5eddf7ddbd1/boto3-1.24.59.tar.gz"
    sha256 "a50b4323f9579cfe22fcf5531fbd40b567d4d74c1adce06aeb5c95fce2a6fb40"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/94/29/b8ef249300edf4584384f725d20db126b6caf6147aac4d02efebca239dce/botocore-1.27.59.tar.gz"
    sha256 "eda4aed6ee719a745d1288eaf1beb12f6f6448ad1fa12f159405db14ba9c92cf"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/4d/91/5837e9f9e77342bb4f3ffac19ba216eef2cd9b77d67456af420e7bafe51d/cachetools-5.3.0.tar.gz"
    sha256 "13dfddc7b8df938c21a940dfa6557ce6e94a2f1cdfa58eb90c805721d58f2c14"
  end

  resource "celery" do
    url "https://files.pythonhosted.org/packages/ce/21/41a0028f6d610987c0839250357c1a00f351790b8a448c2eb323caa719ac/celery-5.2.7.tar.gz"
    sha256 "fafbd82934d30f8a004f81e8f7a062e31413a23d444be8ee3326553915958c6d"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "click-didyoumean" do
    url "https://files.pythonhosted.org/packages/2f/a7/822fbc659be70dcb75a91fb91fec718b653326697d0e9907f4f90114b34f/click-didyoumean-0.3.0.tar.gz"
    sha256 "f184f0d851d96b6d29297354ed981b7dd71df7ff500d82fa6d11f0856bee8035"
  end

  resource "click-plugins" do
    url "https://files.pythonhosted.org/packages/5f/1d/45434f64ed749540af821fd7e42b8e4d23ac04b1eda7c26613288d6cd8a8/click-plugins-1.1.1.tar.gz"
    sha256 "46ab999744a9d831159c3411bb0c79346d94a444df9a3a3742e9ed63645f264b"
  end

  resource "click-repl" do
    url "https://files.pythonhosted.org/packages/60/30/11d3f09eff5ae3627bca79563855035e8d241444520500a3c7914eae6a74/click-repl-0.2.0.tar.gz"
    sha256 "cd12f68d745bf6151210790540b4cb064c7b13e571bc64b6957d98d120dacfd8"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/cb/87/17d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fb/configobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  resource "crcmod" do
    url "https://files.pythonhosted.org/packages/6b/b0/e595ce2a2527e169c3bcd6c33d2473c1918e0b7f6826a043ca1245dd4e5b/crcmod-1.7.tar.gz"
    sha256 "dc7051a0db5f2bd48665a990d3ec1cc305a466a77358ca4492826f41f283601e"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/12/e3/c46c274cf466b24e5d44df5d5cd31a31ff23e57f074a2bb30931a8c9b01a/cryptography-39.0.0.tar.gz"
    sha256 "f964c7dcf7802d133e8dbd1565914fa0194f9d683d82411989889ecd701e8adf"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "dictdiffer" do
    url "https://files.pythonhosted.org/packages/61/7b/35cbccb7effc5d7e40f4c55e2b79399e1853041997fcda15c9ff160abba0/dictdiffer-0.9.0.tar.gz"
    sha256 "17bacf5fbfe613ccf1b6d512bd766e6b21fb798822a133aa86098b8ac9997578"
  end

  resource "diskcache" do
    url "https://files.pythonhosted.org/packages/c7/34/d23a9bc5b2a84917879b977f00fdb97a7700b186a32bf7b0cf5f29f4c2d9/diskcache-5.4.0.tar.gz"
    sha256 "8879eb8c9b4a2509a5e633d2008634fb2b0b35c2b36192d89655dbde02419644"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/4b/89/eaa3a3587ebf8bed93e45aa79be8c2af77d50790d15b53f6dfc85b57f398/distro-1.8.0.tar.gz"
    sha256 "02e111d1dc6a50abb8eed6bf31c3e48ed8b0830d1ea2a1b78c61765c2513fdd8"
  end

  resource "dpath" do
    url "https://files.pythonhosted.org/packages/42/97/b95b0cc68026e002471ea595a07962b5250f6a0348e495d8b6c33df88e5b/dpath-2.1.4.tar.gz"
    sha256 "3380a77d0db4abf104125860ff6eb4bd07c97c65b81aad42a609717089a1bed0"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/14/a5/cf61f9209d48abf47d48086e0a0388f1030bb5f7cf2661972eee56ccee3d/dulwich-0.21.2.tar.gz"
    sha256 "d865ae7fd9497d64ce345a6784ff1775b01317fba9632ef9d2dfd7978f1b0d4f"
  end

  resource "dvc-azure" do
    url "https://files.pythonhosted.org/packages/29/39/06f8e62d9f5a961eafb5bbeb53aacd902acc70317667fd7272ad29d87eeb/dvc-azure-2.20.5.tar.gz"
    sha256 "85f6cdda4804a8b07970eaf0456434a3ec985bc2cf4dfd1b3e1da364ab373b2c"
  end

  resource "dvc-data" do
    url "https://files.pythonhosted.org/packages/3e/93/b489e9467b5d721440e754b5cdb425a53cfc444e4f9e28f993c501480a77/dvc-data-0.35.1.tar.gz"
    sha256 "490c651855286a7ff3814d982351330ea2d72fd61c9d753ff0a873c2aa682945"
  end

  resource "dvc-gdrive" do
    url "https://files.pythonhosted.org/packages/5f/73/3e9b4defb9dabbeada2a52a20e9310ed793f8e72088072c98960a80084ff/dvc-gdrive-2.19.1.tar.gz"
    sha256 "da2c1dd5dd5eead9d86255d0c749795620932b8598afad461bcf169d50b6fa21"
  end

  resource "dvc-gs" do
    url "https://files.pythonhosted.org/packages/34/59/8c20c4ced7315d138e8bdd3b94bfabca936ce4a9f8d7f789a6138ab377f3/dvc-gs-2.20.0.tar.gz"
    sha256 "17662fff3ee87b359a2dc2351c5721a351b12a42fe9bb29e2a820132201cd237"
  end

  resource "dvc-hdfs" do
    url "https://files.pythonhosted.org/packages/d0/26/3459a96fb90c2f2e9edaa2d13f57051eb7bbb5d0d0c9dded8531a0ce43df/dvc-hdfs-2.19.0.tar.gz"
    sha256 "bce4b5a3633d018e795d196227714f30bdd701ac5f4c2a627f731b74d43f4aee"
  end

  resource "dvc-http" do
    url "https://files.pythonhosted.org/packages/0c/1c/f54bb7b8cad89057cd93698bb6330efe7d0749666cde6bf11439cb296b28/dvc-http-2.30.0.tar.gz"
    sha256 "66ca32c7c7d9b36b1812dc0e385364ae5cbf0b62085282b601577f0e0d5cf39e"
  end

  resource "dvc-objects" do
    url "https://files.pythonhosted.org/packages/ba/f1/4f56c64e8dd995064450c5f7a952cbeea1743baef4b830a8c5fa6e6fb396/dvc-objects-0.19.0.tar.gz"
    sha256 "6a1b0e2b5ad861b86b50f3d866e5b973cf18cd105116205d80ecd0d710dff9f1"
  end

  resource "dvc-oss" do
    url "https://files.pythonhosted.org/packages/a9/76/1f612a3e4c9c734ae8fa091cb9199c1c2ea1d498415ba1ccbb50ef8d6805/dvc-oss-2.19.0.tar.gz"
    sha256 "0927f3b0346a59fd31685ecbda2d6f099b74b3def7d574a6af23992ef3851b4b"
  end

  resource "dvc-render" do
    url "https://files.pythonhosted.org/packages/a6/5f/e0c9628caea0fc11e3529e40dc05cfdd31fc100ca3e0699880d454831f2a/dvc-render-0.0.17.tar.gz"
    sha256 "3b119edd39610dff102a60f6735a9bbd4b68ecdb463a65838013a2782e7c7b51"
  end

  resource "dvc-s3" do
    url "https://files.pythonhosted.org/packages/cf/09/0575ee27b864fec363014d6f1032839a3d73413e48a698cd0eae793f5065/dvc-s3-2.21.0.tar.gz"
    sha256 "004079372a7a8fb997d00380d2b85e81de2af313ff3cec7d27aca7d4fa6ed279"
  end

  resource "dvc-ssh" do
    url "https://files.pythonhosted.org/packages/b5/e7/e47c458ff7a98b4a89ce11c23ea128b96f6bc42eb9f715201a3dd14fc86a/dvc-ssh-2.20.0.tar.gz"
    sha256 "47b06bba9ac2c39c509b6139856a169d52f5260d8fc6dbcdbb1a46683f1cc45b"
  end

  resource "dvc-studio-client" do
    url "https://files.pythonhosted.org/packages/d4/51/b4b8292de2511bb9aad9dc28cac99230680b7bc0906e832a89ccf18f9e6b/dvc-studio-client-0.3.0.tar.gz"
    sha256 "dabe29fbf55795de82faf8157a35fa9c00fe0553867ef8013281503607a1f66b"
  end

  resource "dvc-task" do
    url "https://files.pythonhosted.org/packages/e7/38/c3d5e402d8121e7e33a8a152ac26132bae3875d0f0fe40ce91770ca19828/dvc-task-0.1.11.tar.gz"
    sha256 "ea22d9f715c73b468a1bd645cec8c31320abda99d5753410caaf57f1fdcaac88"
  end

  resource "dvc-webdav" do
    url "https://files.pythonhosted.org/packages/dc/89/76a5782ed61ebf802190f76178488308697fd68fa58b998d8f3e9c04ad16/dvc-webdav-2.19.0.tar.gz"
    sha256 "d44977617ef4bffb5bc8e783fac5af0a1eb592cfef9d1d7c56cd28f0e3da05a5"
  end

  resource "dvc-webhdfs" do
    url "https://files.pythonhosted.org/packages/d2/a4/f975f7ebac05fe70b3fc2621a30958d330b827fc8814c6a6ca388f503cf3/dvc-webhdfs-2.19.0.tar.gz"
    sha256 "fc438e40fe9c0b5cc213c0b0f8767f5bd5025397bc58fc61b097f86ae0028ff9"
  end

  resource "dvclive" do
    url "https://files.pythonhosted.org/packages/66/53/8e7d43ce8d951961f618a5ff45ceabf1d00665753ab5d342fe9e3ed65efa/dvclive-1.3.2.tar.gz"
    sha256 "0b2996e57aa37c3308d51ef3bf76a8754ea5a749d7ba1f6af4bf94b53a614279"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/0b/dc/eac02350f06c6ed78a655ceb04047df01b02c6b7ea3fc02d4df24ca87d24/filelock-3.9.0.tar.gz"
    sha256 "7b319f24340b51f55a2bf7a12ac0755a9b03e718311dac567a0f4f7fabd2f5de"
  end

  resource "flatten-dict" do
    url "https://files.pythonhosted.org/packages/89/c6/5fe21639369f2ea609c964e20870b5c6c98a134ef12af848a7776ddbabe3/flatten-dict-0.4.2.tar.gz"
    sha256 "506a96b6e6f805b81ae46a0f9f31290beb5fa79ded9d80dbe1b7fa236ab43076"
  end

  resource "flufl.lock" do
    url "https://files.pythonhosted.org/packages/35/33/d3baecd2545b9ae842f4df356aaa4a1816191eff737264542e9d27c5ec3b/flufl.lock-7.1.1.tar.gz"
    sha256 "af14172b35bbc58687bd06b70d1693fd8d48cbf0ffde7e51a618c148ae24042d"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/e9/10/d629476346112b85c912527b9080944fd2c39a816c2225413dbc0bb6fcc0/frozenlist-1.3.3.tar.gz"
    sha256 "58bcc55721e8a90b88332d6cd441261ebb22342e238296bb330968952fbb3a6a"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/44/7c/fb753d18e2eeb186a47ecd6939326f7633a027fe23a44ee7912978e64819/fsspec-2022.11.0.tar.gz"
    sha256 "259d5fd5c8e756ff2ea72f42e7613c32667dc2049a4ac3d84364a7ca034acb8b"
  end

  resource "funcy" do
    url "https://files.pythonhosted.org/packages/2d/0d/65e6824020a10fee9ea07ec2e4a1527249c1cbf04486e0dfe2a71604b7d2/funcy-1.17.tar.gz"
    sha256 "40b9b9a88141ae6a174df1a95861f2b82f2fdc17669080788b73a3ed9370e968"
  end

  resource "gcsfs" do
    url "https://files.pythonhosted.org/packages/9d/f1/79834a15a341c42ddca882b5dcf06295890faf43d8277aaa458fdbc5e27e/gcsfs-2022.11.0.tar.gz"
    sha256 "84d0caada7097e357d735d7e16e8064f0819d28746101d6f65ff42938557e831"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/4b/47/dc98f3d5d48aa815770e31490893b92c5f1cd6c6cf28dd3a8ae0efffac14/gitdb-4.0.10.tar.gz"
    sha256 "6eb990b69df4e15bad899ea868dc46572c3f75339735663b81de79b06f17eb9a"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/ef/8d/50658d134d89e080bb33eb8e2f75d17563b5a9dfb75383ea1a78e1df6fff/GitPython-3.1.30.tar.gz"
    sha256 "769c2d83e13f5d938b7688479da374c4e3d49f71549aaf462b646db9602ea6f8"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/2b/15/7bafa5379a228ed72baf769eea5e6019a944469fe637ea0742c0351109bf/google-api-core-2.11.0.tar.gz"
    sha256 "4b9bb5d5a380a0befa0573b302651b8a9a89262c1730e37bf423cec511804c22"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/4a/af/6e9ba1d552043c69bddeb761126fe9c9c0a8e896d35a304785d132571523/google-api-python-client-2.73.0.tar.gz"
    sha256 "7e860e3ec27b504fb797fa23c07c012a874dd736491fddbe50a20d3bdde8ace6"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/a9/b8/106bf395ad5be94bfd1e4c157a36db6dfcca445f72ff63458358d9203157/google-auth-2.16.0.tar.gz"
    sha256 "ed7057a101af1146f0554a769930ac9de506aeca4fd5af6543ebe791851a9fbd"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/c6/b5/a9e956fd904ecb34ec9d297616fe98fa4106fc12f3b0a914dec983c267b9/google-auth-httplib2-0.1.0.tar.gz"
    sha256 "a07c39fd632becacd3f07718dfd6021bf396978f03ad3ce4321d060015cc30ac"
  end

  resource "google-auth-oauthlib" do
    url "https://files.pythonhosted.org/packages/06/98/52a79d64ca8fd2e37eff8da6c78c26b2209f19d8ace8cafd1634453c4393/google-auth-oauthlib-0.8.0.tar.gz"
    sha256 "81056a310fb1c4a3e5a7e1a443e1eb96593c6bbc55b26c0261e4d3295d3e6593"
  end

  resource "google-cloud-core" do
    url "https://files.pythonhosted.org/packages/40/4b/f4cebb92fe965f02f4a9c06f16355cf83a61a2d5db110df9af71191c830a/google-cloud-core-2.3.2.tar.gz"
    sha256 "b9529ee7047fd8d4bf4a2182de619154240df17fbe60ead399078c1ae152af9a"
  end

  resource "google-cloud-storage" do
    url "https://files.pythonhosted.org/packages/9f/9c/8cd4da7df57284832c3853aa565de278ca6d33a47ebe6722628488dc01ca/google-cloud-storage-2.7.0.tar.gz"
    sha256 "1ac2d58d2d693cb1341ebc48659a3527be778d9e2d8989697a2746025928ff17"
  end

  resource "google-crc32c" do
    url "https://files.pythonhosted.org/packages/d3/a5/4bb58448fffd36ede39684044df93a396c13d1ea3516f585767f9f960352/google-crc32c-1.5.0.tar.gz"
    sha256 "89284716bc6a5a415d4eaa11b1726d2d60a0cd12aadf5439828353662ede9dd7"
  end

  resource "google-resumable-media" do
    url "https://files.pythonhosted.org/packages/88/11/ea0db6fe28017487dd1e2c6bc3623ea2dc4655947d6f571c6207b6d9693c/google-resumable-media-2.4.1.tar.gz"
    sha256 "15b8a2e75df42dc6502d1306db0bce2647ba6013f9cd03b6e17368c0886ee90a"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/41/43/613cbd071413f6b2a3427f905bc8a8f0f3da202a6e715d78aa22b1f35271/googleapis-common-protos-1.58.0.tar.gz"
    sha256 "c727251ec025947d545184ba17e3578840fc3a24a0516a020479edab660457df"
  end

  # pypi artifact issue, https://github.com/bdcht/grandalf/issues/26
  resource "grandalf" do
    url "https://github.com/bdcht/grandalf/archive/refs/tags/v0.8.tar.gz"
    sha256 "82d80072e5a1928bc46d94a54d2d92a38f73da0af052efc84ce34b5f4601dfa2"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/61/42/5c456b02816845d163fab0f32936b6a5b649f3f915beff6f819f4f6c90b2/httpcore-0.16.3.tar.gz"
    sha256 "c5d6f04e2fc530f39e0c077e6a30caa53f1451096120f1f38b954afd0b17c0cb"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/c2/37/a093aaa902f6b2301f0f2cff5285548dbc4ab9b9a29215eb440381cbb32b/httplib2-0.21.0.tar.gz"
    sha256 "fc144f091c7286b82bec71bdbd9b27323ba709cc612568d3000893bfd9cb4b34"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/f5/50/04d5e8ee398a10c767a341a25f59ff8711ae3adf0143c7f8b45fc560d72d/httpx-0.23.3.tar.gz"
    sha256 "9818458eb565bb54898ccb9b8b251a28785dd4a55afbc23d0eb410754fe7d0f9"
  end

  resource "hydra-core" do
    url "https://files.pythonhosted.org/packages/bf/91/fe33688b6a28cfefd0f1d72c52ed47d71af43aa895e1e8381b5bf462635c/hydra-core-1.3.1.tar.gz"
    sha256 "8dd42d551befc43dfca0c612cbd58c4f3e273dbd97a87214c1a030ba557d238b"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/db/7a/c0a56c7d56c7fa723988f122fa1f1ccf8c5c4ccc48efad0d214b49e5b1af/isodate-0.6.1.tar.gz"
    sha256 "48c5881de7e8b0a0d648cb024c8062dc84e7b840ed81e864c7614fd3c127bde9"
  end

  resource "iterative-telemetry" do
    url "https://files.pythonhosted.org/packages/9d/39/15fc32f1ba9b3c3d0ffdeca9a3abb26778ea4dda94ca256c2f84d632f40e/iterative-telemetry-0.0.6.tar.gz"
    sha256 "721bc0bfa962eb4d80877d5a4e04c758881ea7e7e7529a3f0e9bfd7e829365e2"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "knack" do
    url "https://files.pythonhosted.org/packages/2e/9c/b6fc4ca774d3730fd1c2c9fe516afc223562976a4bcf0cec6e9e4dbf38c5/knack-0.10.1.tar.gz"
    sha256 "c5728128297e6d269791085cf96c2ffdfcef58cf83c634a5cb92eb03b2929838"
  end

  resource "kombu" do
    url "https://files.pythonhosted.org/packages/e1/9e/3811be7d86ac3be6d1a1f5098f95b1d8e2519c12c537719c7e13c8a12800/kombu-5.2.4.tar.gz"
    sha256 "37cee3ee725f94ea8bb173eaab7c1760203ea53bbebae226328600f9d2799610"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/33/e9/ac8a93e9eda3891ecdfecf5e01c060bbd2c44d4e3e77efc83b9c7ce9db32/markdown-it-py-2.1.0.tar.gz"
    sha256 "cf7e59fed14b5ae17c0006eff14a2d9a00ed5f3a846148153899a0224e2c07da"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/c5/f8/05c343f2652b5b32f063bc908f428ffd14da65939d96b7adc48986f242a8/msal-1.20.0.tar.gz"
    sha256 "78344cd4c91d6134a593b5e3e45541e666e37b747ff8a6316c3668dd1e6ab6b2"
  end

  resource "msal-extensions" do
    url "https://files.pythonhosted.org/packages/33/5e/2e23593c67df0b21ffb141c485ca0ae955569203d7ff5064040af968cb81/msal-extensions-1.0.0.tar.gz"
    sha256 "c676aba56b0cce3783de1b5c5ecfe828db998167875126ca4b47dc6436451354"
  end

  resource "msrest" do
    url "https://files.pythonhosted.org/packages/68/77/8397c8fb8fc257d8ea0fa66f8068e073278c65f05acb17dcb22a02bfdc42/msrest-0.7.1.zip"
    sha256 "6e7661f46f3afd88b75667b7187a92829924446c7ea1d169be8c4bb7eeb788b9"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/4a/15/bd620f7a6eb9aa5112c4ef93e7031bcd071e0611763d8e17706ef8ba65e0/multidict-6.0.4.tar.gz"
    sha256 "3666906492efb76453c0e7b97f2cf459b0682e7402c0489a95484965dbc1da49"
  end

  resource "nanotime" do
    url "https://files.pythonhosted.org/packages/d5/54/6d5924f59cf671326e7809f4b3f70fa8df535d67e952ad0b6fea02f52faf/nanotime-0.5.2.tar.gz"
    sha256 "c7cc231fc5f6db401b448d7ab51c96d0a4733f4b69fabe569a576f89ffdf966b"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/99/f9/d45c9ecf50a6b67a200e0bbd324201b5cd777dfc0e6c8f6d1620ce5a7ada/networkx-3.0.tar.gz"
    sha256 "9a9992345353618ae98339c2b63d8201c381c2944f38a2ab49cb45a4c667e412"
  end

  resource "oauth2client" do
    url "https://files.pythonhosted.org/packages/a6/7b/17244b1083e8e604bf154cf9b716aecd6388acd656dd01893d0d244c94d9/oauth2client-4.1.3.tar.gz"
    sha256 "d486741e451287f69568a4d26d70d9acd73a2bbfa275746c535b4209891cccc6"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/6d/fa/fbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670/oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "omegaconf" do
    url "https://files.pythonhosted.org/packages/09/48/6388f1bb9da707110532cb70ec4d2822858ddfb44f1cdf1233c20a80ea4b/omegaconf-2.3.0.tar.gz"
    sha256 "d5d4b6d29955cc50ad50c46dc269bcd92c6e00f5f90d23ab5fee7bfca4ba4cc7"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/cb/07/e9a22e4d9304ca15455d2ae1696d1c74c3881b72450c8c1e07694029b6b9/orjson-3.8.5.tar.gz"
    sha256 "77a3b2bd0c4ef7723ea09081e3329dac568a62463aed127c1501441b07ffc64b"
  end

  resource "oss2" do
    url "https://files.pythonhosted.org/packages/7a/d2/33b2607395c625f685c9e225d94fa2f56a4debabfe53b9b00c9eaed22f6d/oss2-2.16.0.tar.gz"
    sha256 "a08ca287dbadb19767a204297540c185f5ccccad7ef6f9ca3a180f77b6dc8376"
  end

  resource "ossfs" do
    url "https://files.pythonhosted.org/packages/b1/9c/a68f190e6043928b9e88f65324f4a5d7ad0a2511ce7378d19079cf2b0682/ossfs-2023.1.0.tar.gz"
    sha256 "da3c071eee26b17cd6a9dcf6e3fb162f67bf5946275204f3027ecff0fa935e24"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/32/1a/6baf904503c3e943cae9605c9c88a43b964dea5b59785cf956091b341b08/pathspec-0.10.3.tar.gz"
    sha256 "56200de4077d9d0791465aa9095a01d421861e405b5096955051deefd697d6f6"
  end

  resource "portalocker" do
    url "https://files.pythonhosted.org/packages/1f/f8/969e6f280201b40b31bcb62843c619f343dcc351dff83a5891530c9dd60e/portalocker-2.7.0.tar.gz"
    sha256 "032e81d534a88ec1736d03f780ba073f047a06c478b06e2937486f334e955c51"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/fb/93/180be2342f89f16543ec4eb3f25083b5b84eba5378f68efff05409fb39a9/prompt_toolkit-3.0.36.tar.gz"
    sha256 "3e163f254bef5a03b146397d7c1963bd3e2812f0964bb9a24e6ec761fd28db63"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/3d/7d/d05864a69e452f003c0d77e728e155a89a2a26b09e64860ddd70ad64fb26/psutil-5.9.4.tar.gz"
    sha256 "3d7f9739eb435d4b1338944abe23f49584bde5395f27487d2ee25ad9a8774a62"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/db/fffec68299e6d7bad3d504147f9094830b704527a7fc098b721d38cc7fa7/pyasn1-0.4.8.tar.gz"
    sha256 "aef77c9fb94a3ac588e87841208bdec464471d9871bd5050a287cc9a475cd0ba"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/88/87/72eb9ccf8a58021c542de2588a867dbefc7556e14b2866d1e40e9e2b587e/pyasn1-modules-0.2.8.tar.gz"
    sha256 "905f84c712230b2c592c19470d3ca8d552de726050d1d1716282a1f6146be65e"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/0d/66/5e4a14e91ffeac819e6888037771286bc1b86869f25d74d60bc4a61d2c1e/pycryptodome-3.16.0.tar.gz"
    sha256 "0e45d2d852a66ecfb904f090c3f87dc0dfb89a499570abad8590f10d9cffb350"
  end

  resource "pydot" do
    url "https://files.pythonhosted.org/packages/13/6e/916cdf94f9b38ae0777b254c75c3bdddee49a54cc4014aac1460a7a172b3/pydot-1.4.2.tar.gz"
    sha256 "248081a39bcb56784deb018977e428605c1c758f10897a339fce1dd728ff007d"
  end

  resource "PyDrive2" do
    url "https://files.pythonhosted.org/packages/05/e8/4d227db64308b3ccc81e7ef5df2432c4b97ecc835b9f291fd07f5be93c58/PyDrive2-1.15.0.tar.gz"
    sha256 "3ae06b66bf963f43524989c87f4d678039441fe059993c6703fb33cc3c6d8aec"
  end

  resource "pygit2" do
    url "https://files.pythonhosted.org/packages/43/9a/f4375f39d2de971750a7c16bd7ab9cc53368f395edaac59b32e9b3f62ce9/pygit2-1.11.1.tar.gz"
    sha256 "793f583fd33620f0ac38376db0f57768ef2922b89b459e75b1ac440377eb64ec"
  end

  resource "pygtrie" do
    url "https://files.pythonhosted.org/packages/b9/13/55deec25bf09383216fa7f1dfcdbfca40a04aa00b6d15a5cbf25af8fce5f/pygtrie-2.5.0.tar.gz"
    sha256 "203514ad826eb403dab1d2e2ddd034e0d1534bbe4dbe0213bb0593f66beba4e2"
  end

  resource "PyJWT" do
    url "https://files.pythonhosted.org/packages/75/65/db64904a7f23e12dbf0565b53de01db04d848a497c6c9b87e102f74c9304/PyJWT-2.6.0.tar.gz"
    sha256 "69285c7e31fc44f68a1feb309e948e0df53259d579295e6cfe2b1792329f05fd"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/af/6e/0706d5e0eac08fcff586366f5198c9bf0a8b46f0f45b1858324e0d94c295/pyOpenSSL-23.0.0.tar.gz"
    sha256 "c1cc5f86bcacefc84dada7d31175cae1b1518d5f60d3d0bb595a67822a868a6f"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/03/3e/dc5c793b62c60d0ca0b7e58f1fdd84d5aaa9f8df23e7589b39cc9ce20a03/pytz-2022.7.1.tar.gz"
    sha256 "01a0681c4b9684a28304615eba55d1ab31ae00bf68ec157ec3708a8182dbbcd0"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/95/52/531ef197b426646f26b53815a7d2a67cb7a331ef098bb276db26a68ac49f/requests-oauthlib-1.3.1.tar.gz"
    sha256 "75beac4a47881eeb94d5ea5d6ad31ef88856affe2332b9aafb52c6452ccf0d7a"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/79/30/5b1b6c28c105629cc12b33bdcbb0b11b5bb1880c6cfbd955f9e792921aa8/rfc3986-1.5.0.tar.gz"
    sha256 "270aaf10d87d0d4e095063c65bf3ddbc6ee3d0b226328ce21e036f946e421835"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/9e/5e/c3dc3ea32e2c14bfe46e48de954dd175bff76bcc549dd300acb9689521ae/rich-13.2.0.tar.gz"
    sha256 "f1a00cdd3eebf999a15d85ec498bfe0b1a77efe9b34f645768a54132ef444ac5"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/aa/65/7d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52/rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/46/a9/6ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3c/ruamel.yaml-0.17.21.tar.gz"
    sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
  end

  resource "s3fs" do
    url "https://files.pythonhosted.org/packages/ac/cf/a3e7af8c267cfe138cb5a12eb0608134d485b1e217e742de624466a04487/s3fs-2022.11.0.tar.gz"
    sha256 "10c5ac283a4f5b67ffad6d1f25ff7ee026142750c5c5dc868746cd904f617c33"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/e1/eb/e57c93d5cd5edf8c1d124c831ef916601540db70acd96fa21fe60cef1365/s3transfer-0.6.0.tar.gz"
    sha256 "2ed07d3866f523cc561bf4a00fc5535827981b117dd7876f036b0c1aca42c947"
  end

  resource "scmrepo" do
    url "https://files.pythonhosted.org/packages/e8/67/5ff9bed103c78a1f408f9e3aee69718545cff914a70091dc36107c988c7a/scmrepo-0.1.6.tar.gz"
    sha256 "ed083676c3da26eb98d9fe43b7f00814094109be1c51c023143070187eebf4d6"
  end

  resource "shortuuid" do
    url "https://files.pythonhosted.org/packages/1e/c6/ba2dd56e3996a1919984645ca0aaf20c4879cc1227c50a4be08f52b19ad0/shortuuid-1.0.11.tar.gz"
    sha256 "fc75f2615914815a8e4cb1501b3a513745cb66ef0fd5fc6fb9f8c3fa3481f789"
  end

  resource "shtab" do
    url "https://files.pythonhosted.org/packages/3c/4c/7d8363edcd34b5fb6d5fd24be8224cdae2de39bc558a84394655822b0ef3/shtab-1.5.8.tar.gz"
    sha256 "1f944e2e33c1554be69e6b26ef638ba3b516ac9449fdd2a40d197f9061c8bed8"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/cd/50/d49c388cae4ec10e8109b1b833fd265511840706808576df3ada99ecb0ac/sniffio-1.3.0.tar.gz"
    sha256 "e60305c5e5d314f5389259b7f22aaa33d8f7dee49763119234af3755c55b9101"
  end

  resource "sqltrie" do
    url "https://files.pythonhosted.org/packages/02/ba/cd984affb4d7e2935d7c2c3e72f5434ef901d22cc56681b7f1563f4459a4/sqltrie-0.0.26.tar.gz"
    sha256 "c2989a1b643e95bb29f5c2514ceaa07e70524f76622788064be90a6cd14145e0"
  end

  resource "sshfs" do
    url "https://files.pythonhosted.org/packages/50/83/8737feab01c85bf7c5b191ec06f2a807ac36eb88093844e7e9fea971bb53/sshfs-2023.1.0.tar.gz"
    sha256 "b32215b408bb68f7953c948a1dd0c9200aec623d26b4800fd74e2f47755bd544"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/ff/04/58b4c11430ed4b7b8f1723a5e4f20929d59361e9b17f0872d69681fd8ffd/tomlkit-0.11.6.tar.gz"
    sha256 "71b952e5721688937fb02cf9d354dbcf0785066149d2855e44531ebdd2b65d73"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/c1/c2/d8a40e5363fb01806870e444fc1d066282743292ff32a9da54af51ce36a2/tqdm-4.64.1.tar.gz"
    sha256 "5f4f682a004951c1b450bc753c710e9280c5746ce6ffedee253ddbcbf54cf1e4"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/d2/5a/4742fdba39cd02a56226815abfa72fe0aa81c33bed16ed045647d6000eba/uritemplate-4.1.1.tar.gz"
    sha256 "4346edfc5c3b79f694bccd6d6099a322bbeb628dbf2cd86eea55a456ce5124f0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
  end

  resource "vine" do
    url "https://files.pythonhosted.org/packages/66/b2/8954108816865edf2b1e0d24f3c2c11dfd7232f795bcf1e4164fb8ee5e15/vine-5.0.0.tar.gz"
    sha256 "7d3b1624a953da82ef63462013bbd271d3eb75751489f9807598e8f340bd637e"
  end

  resource "voluptuous" do
    url "https://files.pythonhosted.org/packages/72/0c/0ed7352eeb7bd3d53d2c0ae87fa1e222170f53815b8df7d9cdce7ffedec0/voluptuous-0.13.1.tar.gz"
    sha256 "e8d31c20601d6773cb14d4c0f42aee29c6821bbd1018039aac7ac5605b489723"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/5e/5f/1e4bd82a9cc1f17b2c2361a2d876d4c38973a997003ba5eb400e8a932b6c/wcwidth-0.2.6.tar.gz"
    sha256 "a5220780a404dbe3353789870978e472cfe477761f06ee55077256e509b156d0"
  end

  resource "webdav4" do
    url "https://files.pythonhosted.org/packages/be/cc/172a99d6bee59597063e8a920ca5c7aeeced8f624453110490deba46819b/webdav4-0.9.8.tar.gz"
    sha256 "fc7748df33a375de13ddb5f4594f5799f9f3dc13c005b7b9c45c120aad745694"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/11/eb/e06e77394d6cf09977d92bff310cb0392930c08a338f99af6066a5a98f92/wrapt-1.14.1.tar.gz"
    sha256 "380a85cf89e0e69b7cfbe2ea9f765f004ff419f34194018a6827ac0e3edfed4d"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/c4/1e/1b204050c601d5cd82b45d5c8f439cb6f744a2ce0c0a6f83be0ddf0dc7b2/yarl-1.8.2.tar.gz"
    sha256 "49d43402c6e3013ad0978602bf6bf5328535c48d192304b91b97a3c6790b1562"
  end

  resource "zc.lockfile" do
    url "https://files.pythonhosted.org/packages/11/98/f21922d501ab29d62665e7460c94f5ed485fd9d8348c126697947643a881/zc.lockfile-2.0.tar.gz"
    sha256 "307ad78227e48be260e64896ec8886edc7eae22d8ec53e4d528ab5537a83203b"
  end

  def install
    # NOTE: dvc uses this file [1] to know which package it was installed from,
    # so that it is able to provide appropriate instructions for updates.
    # [1] https://github.com/iterative/dvc/blob/0.68.1/dvc/utils/pkg.py
    File.write("dvc/utils/build.py", "PKG = \"brew\"")

    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"dvc", "completion", "-s", shells: [:bash, :zsh])
  end

  test do
    output = shell_output("#{bin}/dvc doctor 2>&1")
    assert_match "gdrive", output
    assert_match "gs", output
    assert_match "http", output
    assert_match "https", output
    assert_match "oss", output
    assert_match "s3", output
    assert_match "ssh", output
    assert_match "webdav", output
    assert_match "webdavs", output
    assert_match "webhdfs", output
  end
end
