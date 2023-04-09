class PodmanCompose < Formula
  include Language::Python::Virtualenv

  desc "Alternative to docker-compose using podman"
  homepage "https://github.com/containers/podman-compose"
  url "https://files.pythonhosted.org/packages/65/a8/d77d2eaa85414d013047584d3aa10fac47edb328f5180ca54a13543af03a/podman-compose-1.0.6.tar.gz"
  sha256 "2db235049fca50a5a4ffd511a917808c960dacb8defd5481dd8b36a77d4da2e5"
  license "GPL-2.0-only"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8a3150b796d0691711da117dde78a8438cc2391206709dd0558506ac1a5cbe5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8a3150b796d0691711da117dde78a8438cc2391206709dd0558506ac1a5cbe5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b8a3150b796d0691711da117dde78a8438cc2391206709dd0558506ac1a5cbe5"
    sha256 cellar: :any_skip_relocation, ventura:        "1d695df8b43c37c854857464661f929488002ad7bf745483b5e4fd081803b5dc"
    sha256 cellar: :any_skip_relocation, monterey:       "1d695df8b43c37c854857464661f929488002ad7bf745483b5e4fd081803b5dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d695df8b43c37c854857464661f929488002ad7bf745483b5e4fd081803b5dc"
    sha256 cellar: :any_skip_relocation, catalina:       "1d695df8b43c37c854857464661f929488002ad7bf745483b5e4fd081803b5dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be33e397146ed2ab7795786284cbeb1fda7fe45ca235925c075bd69f19c3f299"
  end

  depends_on "podman"
  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/31/06/1ef763af20d0572c032fa22882cfbfb005fba6e7300715a37840858c919e/python-dotenv-1.0.0.tar.gz"
    sha256 "a8df96034aae6d2d50a4ebe8216326c61c3eb64836776504fcca410e5937a3ba"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    port = free_port

    (testpath/"compose.yml").write <<~EOS
      version: "3"
      services:
        test:
          image: nginx:1.22
          ports:
            - #{port}:80
          environment:
            - NGINX_PORT=80
    EOS

    # If it's trying to connect to Podman, we know it at least found the
    # compose.yml file and parsed/validated the contents
    expected = OS.linux? ? "Error: cannot re-exec process" : "Cannot connect to Podman"
    assert_match expected, shell_output("#{bin}/podman-compose up -d 2>&1", 1)
    assert_match expected, shell_output("#{bin}/podman-compose down 2>&1")
  end
end
