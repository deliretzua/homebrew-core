class Jhead < Formula
  desc "Extract Digicam setting info from EXIF JPEG headers"
  homepage "https://github.com/Matthias-Wandel/jhead"
  url "https://github.com/Matthias-Wandel/jhead/archive/3.08.tar.gz"
  sha256 "999a81b489c7b2a7264118f194359ecf4c1b714996a2790ff6d5d2f3940f1e9f"
  license :public_domain

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47c50f4a450eba0ecfa6bdcd466d192724697b4a5885181ae98283dd4c79e4c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e473e54dcc077f4b803d1fa3acf390d8d74845f9c01e8316dbccf195844b5738"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ba17f494afc0590a876112f9f7f6b00664fbd1ad62ec3a9a21a5941188b9bbe"
    sha256 cellar: :any_skip_relocation, ventura:        "5be3868791c615b094607a955575219af8a7286a04e24b4abef54bb99c1bb44d"
    sha256 cellar: :any_skip_relocation, monterey:       "cd587b58853b3f1adbdb7bf1cf7bf019d7f86354ffa4ba3de04ec60220858d6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff1612a2a1d386e153b934b790f6e3e4897a0cb9509805de91f0cf432a422f57"
    sha256 cellar: :any_skip_relocation, catalina:       "57866edae4ac5a6b63988d3f7c9c1d261fa33eaff6dc1e6833a086fda2a7671f"
    sha256 cellar: :any_skip_relocation, mojave:         "1d772617f005a7b1381d78c133e2745e9ca7e31cb6a5fd5428bd2f973bcfae45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15b04dc8681a47de34f7d95028ad979706403157d88bef21cdfc97b5f89393cf"
  end

  def install
    ENV.deparallelize
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    cp test_fixtures("test.jpg"), testpath
    system "#{bin}/jhead", "-autorot", "test.jpg"
  end
end
