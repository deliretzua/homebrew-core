class Schemathesis < Formula
  include Language::Python::Virtualenv

  desc "Testing tool for web applications with specs"
  homepage "https://schemathesis.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/de/2a/5e3684d43880dab238a08d41f10909b47d77df658d87fc06432c9cd6c33d/schemathesis-3.17.4.tar.gz"
  sha256 "d0895c281a7d2947c7fe79c99fa5196e1e72c3aa28aa8df614b199f198c8bc7e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0644951bd2291b6b9f4e7cec3648083975e7653ee0f54f86011cd6ff24075833"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "269bad9f8b55e3513f0327d25f8eb26fbce0e849147435a49851fdcdf55cc534"
    sha256 cellar: :any_skip_relocation, monterey:       "33c625238885cf3e1f63e21af2a4b069a028f103a35db5334e71b698f6ea3a42"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef612414dfd9f78cfeaaf4f8827e6d5bbc576d1852803b354f7b981aad5982b7"
    sha256 cellar: :any_skip_relocation, catalina:       "ae2c4b2f81fc0d7016aa46d496ac80c41e8da59cc698d565919bee7e8045880a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1987e5ed09858249595a198affb56a6811dd699b4147a06c0e1a22be8296900"
  end

  depends_on "jsonschema"
  depends_on "python-typing-extensions"
  depends_on "python@3.10"
  depends_on "pyyaml"
  depends_on "six"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/8b/94/6928d4345f2bc1beecbff03325cad43d320717f51ab74ab5a571324f4f5a/anyio-3.6.2.tar.gz"
    sha256 "25ea0d673ae30af41a0c442f81cf3b38c7e79fdc7b60335a4c14e05eb0947421"
  end

  resource "backoff" do
    url "https://files.pythonhosted.org/packages/47/d7/5bbeb12c44d7c4f2fb5b56abce497eb5ed9f34d85701de869acedd602619/backoff-2.2.1.tar.gz"
    sha256 "03f829f5bb1923180821643f8753b0502c3b682293992485b0eef2807afa5cba"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cb/a4/7de7cd59e429bd0ee6521ba58a75adaec136d32f91a761b28a11d8088d44/certifi-2022.9.24.tar.gz"
    sha256 "0d9c601124e5a6ba9712dbc60d9c53c21e34f5f641fe83002317394311bdce14"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/2b/65/24d033a9325ce42ccbfa3ca2d0866c7e89cc68e5b9d92ecaba9feef631df/colorama-0.4.5.tar.gz"
    sha256 "e6c6b4334fc50988a639d9b98aa429a0b57da6e17b9a44f0451f930b6967b7a4"
  end

  resource "curlify" do
    url "https://files.pythonhosted.org/packages/fa/2c/9254b2294d0250291560d78e16e5cd764b8e2caa75d4cad1e8ae9d73899d/curlify-2.2.1.tar.gz"
    sha256 "0d3f02e7235faf952de8ef45ef469845196d30632d5838bcd5aee217726ddd6d"
  end

  resource "exceptiongroup" do
    url "https://files.pythonhosted.org/packages/cb/b2/ca0513bb83e236707e22218d1e52d5f5b38b608653d385edb3fb3a03d35f/exceptiongroup-1.0.0rc9.tar.gz"
    sha256 "9086a4a21ef9b31c72181c77c040a074ba0889ee56a7b289ff0afb0d97655f96"
  end

  resource "graphql-core" do
    url "https://files.pythonhosted.org/packages/ee/a6/94df9045ca1bac404c7b394094cd06713f63f49c7a4d54d99b773ae81737/graphql-core-3.2.3.tar.gz"
    sha256 "06d2aad0ac723e35b1cb47885d3e5c45e956a53bc1b209a9fc5369007fe46676"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/bd/e9/72c3dc8f7dd7874812be6a6ec788ba1300bfe31570963a7e788c86280cb9/h11-0.12.0.tar.gz"
    sha256 "47222cb6067e4a307d535814917cd98fd0a57b6788ce715755fa2b6c28b56042"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/42/98/44c3e51a0655eae75adefee028c9bada7427a90f63105e54f5e735946f50/httpcore-0.15.0.tar.gz"
    sha256 "18b68ab86a3ccf3e7dc0f43598eaddcf472b602aba29f9aa6ab85fe2ada3980b"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/43/cd/677173d194b4839e5b196709e3819ffca2a4bc58b0538f4ae4be877ad480/httpx-0.23.0.tar.gz"
    sha256 "f28eac771ec9eb4866d3fb4ab65abd42d38c424739e80c08d8d20570de60b0ef"
  end

  resource "hypothesis" do
    url "https://files.pythonhosted.org/packages/8c/f8/cb95c13deea400459dec97c63a4c19166accb99c058a821c554d588f5e7d/hypothesis-6.56.3.tar.gz"
    sha256 "15dae5d993339aefa57e00f5cb5a5817ff300eeb661d96d1c9d094eb62b04c9a"
  end

  resource "hypothesis-graphql" do
    url "https://files.pythonhosted.org/packages/d7/8e/e59c7ffc179e0e5e8f47ff9ca393cef26aa83dc2aa5c25f40d2edc477d5e/hypothesis-graphql-0.9.1.tar.gz"
    sha256 "e766bc21731e1183947e67f2d38c7a156a3904c7403b6bae628d26913553334a"
  end

  resource "hypothesis-jsonschema" do
    url "https://files.pythonhosted.org/packages/81/e0/c2802558d47e179e234f45c5d9dc39ff45d30d28692839a10be391d892fd/hypothesis-jsonschema-0.22.0.tar.gz"
    sha256 "359504080a422924a77263789a00c4995b061991558ff6a8243949f94a4d74fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/23/a2/97899f6bd0e873fed3a7e67ae8d3a08b21799430fb4da15cfedf10d6e2c2/iniconfig-1.1.1.tar.gz"
    sha256 "bc3af051d7d14b2ee5ef9969666def0cd1a000e121eaea580d4a313df4b37f32"
  end

  # only doing this because junit-xml source is not available in PyPI for v1.9
  resource "junit-xml" do
    url "https://github.com/kyrus/python-junit-xml.git",
        revision: "4bd08a272f059998cedf9b7779f944d49eba13a6"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/fa/a7/71c253cdb8a1528802bac7503bf82fe674367e4055b09c28846fdfa4ab90/multidict-6.0.2.tar.gz"
    sha256 "5ff3bd75f38e4c43f1f470f2df7a4d430b821c4ce22be384e1459cb57d6bb013"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/a1/16/db2d7de3474b6e37cbb9c008965ee63835bba517e22cdb8c35b5116b5ce1/pluggy-1.0.0.tar.gz"
    sha256 "4224373bacce55f955a878bf9cfa763c1e360858e330072059e10bad68531159"
  end

  resource "py" do
    url "https://files.pythonhosted.org/packages/98/ff/fec109ceb715d2a6b4c4a85a61af3b40c723a961e8828319fbcb15b868dc/py-1.11.0.tar.gz"
    sha256 "51c75c4126074b472f746a24399ad32f6053d1b34b68d2fa41e558e6f4a98719"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/a4/a7/8c63a4966935b0d0b039fd67ebf2e1ae00f1af02ceb912d838814d772a9a/pytest-7.1.3.tar.gz"
    sha256 "4f365fec2dff9c1162f834d9f18af1ba13062db0c708bf7b946f8a5c76180c39"
  end

  resource "pytest-subtests" do
    url "https://files.pythonhosted.org/packages/b9/ea/3971817de038f8a03e8a1d1833ce5708965c67bacf1455d140f836c6f7f4/pytest-subtests-0.7.0.tar.gz"
    sha256 "95c44c77e3fbede9848bb88ca90b384815fcba8090ef9a9f55659ab163b1681c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/79/30/5b1b6c28c105629cc12b33bdcbb0b11b5bb1880c6cfbd955f9e792921aa8/rfc3986-1.5.0.tar.gz"
    sha256 "270aaf10d87d0d4e095063c65bf3ddbc6ee3d0b226328ce21e036f946e421835"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/cd/50/d49c388cae4ec10e8109b1b833fd265511840706808576df3ada99ecb0ac/sniffio-1.3.0.tar.gz"
    sha256 "e60305c5e5d314f5389259b7f22aaa33d8f7dee49763119234af3755c55b9101"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/b9/41/f72bdaf61d5254da110866361b0d0da8694f7b5d0909b78337f6ebe17f0d/starlette-0.21.0.tar.gz"
    sha256 "b1b52305ee8f7cfc48cde383496f7c11ab897cd7112b33d998b1317dc8ef9027"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/49/05/6bf21838623186b91aedbda06248ad18f03487dc56fbc20e4db384abde6c/tomli_w-1.0.0.tar.gz"
    sha256 "f463434305e0336248cac9c2dc8076b707d8a12d019dd349f5c1e382dd1ae1b9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  resource "Werkzeug" do
    url "https://files.pythonhosted.org/packages/10/cf/97eb1a3847c01ae53e8376bc21145555ac95279523a935963dc8ff96c50b/Werkzeug-2.1.2.tar.gz"
    sha256 "1ce08e8093ed67d638d63879fd1ba3735817f7a80de3674d293f5984f25fb6e6"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/d6/04/255c68974ec47fa754564c4abba8f61f9ed68b869bbbb854198d6259c4f7/yarl-1.8.1.tar.gz"
    sha256 "af887845b8c2e060eb5605ff72b6f2dd2aab7a761379373fd89d314f4752abbf"
  end

  def install
    virtualenv_install_with_resources

    # we depend on jsonschema, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.10")
    jsonschema = Formula["jsonschema"].opt_libexec
    (libexec/site_packages/"homebrew-jsonschema.pth").write jsonschema/site_packages
  end

  test do
    (testpath/"example.json").write <<~EOS
      {
        "openapi": "3.0.3",
        "paths": {}
      }
    EOS
    output = shell_output("#{bin}/st run ./example.json --dry-run")
    assert_match "Schemathesis test session starts", output
    assert_match "Specification version: Open API 3.0.3", output
    assert_match "No checks were performed.", output
  end
end
