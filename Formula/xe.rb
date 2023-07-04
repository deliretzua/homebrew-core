class Xe < Formula
  desc "Simple xargs and apply replacement"
  homepage "https://github.com/leahneukirchen/xe"
  url "https://github.com/leahneukirchen/xe/archive/refs/tags/v0.11.tar.gz"
  sha256 "4087d40be2db3df81a836f797e1fed17d6ac1c788dcf0fd6a904f2d2178a6f1a"
  license :public_domain
  head "https://github.com/leahneukirchen/xe.git", branch: "master"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"input").write "a\nb\nc\nd\n"
    assert_equal "b a\nd c\n", shell_output("#{bin}/xe -f #{testpath}/input -N2 -s 'echo $2 $1'")
  end
end
