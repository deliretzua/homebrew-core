class Rpl < Formula
  include Language::Python::Virtualenv

  desc "Text replacement utility"
  homepage "https://github.com/rrthomas/rpl"
  url "https://files.pythonhosted.org/packages/0b/ff/d3c4712469b296e16d6704ec4a5c5ca02479d824db0de83caee10455cb9d/rpl-1.15.4.tar.gz"
  sha256 "d89c20c3b02079db9e9a6738a0e9c0237b15623a368b6f53fa95cd866ed2630f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "286dbe82c334c92999af55394d6ae990ece5617563f39afe1d7e5d1e7b0510c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46ef9e4c29ce913017b65e176d38f3d7b1a3ab33147c0fafb270cb7b442a2d78"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66905494cd9a1dcff546a819ed9be8dc20113323ae4dc339d346359e8f4752dc"
    sha256 cellar: :any_skip_relocation, ventura:        "c199985afc0139e5a97ba13b719537e1423aa821c424f20af11dae0e78a133d9"
    sha256 cellar: :any_skip_relocation, monterey:       "ec1ccbe3b7a0b822464cbd586bb247a0c5ef5f72781c9a9ec7aabcd0e0169348"
    sha256 cellar: :any_skip_relocation, big_sur:        "b07f269aff8704908beb57b9f6045daaf377805371ca4edc72e362cab4fb7e23"
    sha256 cellar: :any_skip_relocation, catalina:       "edbab26552da9547f8d356ba50bb2d02ce6c10549da2c2c4d5f65a3bc4039b81"
    sha256 cellar: :any_skip_relocation, mojave:         "79ed79d50ceaed30cc0fedaeeead5742208c72b04858863ceaf7951c7cbf8e00"
    sha256 cellar: :any_skip_relocation, high_sierra:    "70b23d5ce18f2dfe58e8c782a00e4ab56d88c1e43b135c9e9ba0c8c387bef470"
    sha256 cellar: :any_skip_relocation, sierra:         "2c9e55b51762d835db949c20f9eba36e83213082db82c69602658e2f28003b80"
    sha256 cellar: :any_skip_relocation, el_capitan:     "175e1f127c8c707b0d90c3c7e4399cc5c1e18410bf8b7f6ec9340dbca4c16e4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d343c559dc0109ebc9ea3c19568ab9a6aa222feeb21c3b94e6f17c98f67f76e3"
  end

  depends_on "python@3.11"

  resource "chainstream" do
    url "https://files.pythonhosted.org/packages/44/fd/ec0c4df1e2b00080826b3e2a9df81c912c8dc7dbab757b55d68af3a51dcf/chainstream-1.0.1.tar.gz"
    sha256 "df4d8fd418b112690e0e6faa4cb6706962e4b6b95ff5c133890fd32157c8d3b7"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/41/32/cdc91dcf83849c7385bf8e2a5693d87376536ed000807fa07f5eab33430d/chardet-5.1.0.tar.gz"
    sha256 "0d62712b956bc154f85fb0a266e2a3c5913c2967e00348701b32411d6def31e5"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/77/5d/98efc9cf46d60f3704cf00f8b3bd81319493639fd4367efb5d02fd29ffc1/regex-2023.5.5.tar.gz"
    sha256 "7d76a8a1fc9da08296462a18f16620ba73bcbf5909e42383b253ef34d9d5141e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test").write "I like water."

    system "#{bin}/rpl", "-v", "water", "beer", "test"
    assert_equal "I like beer.", (testpath/"test").read
  end
end
