class Run < Formula
  desc "Easily manage and invoke small scripts and wrappers"
  homepage "https://github.com/TekWizely/run"
  url "https://github.com/TekWizely/run/archive/v0.11.1.tar.gz"
  sha256 "18f2d5a61c29b8de5dab9581b46efdd815ea367454acec719108c4f3742375db"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2761a21abc5248ef96c4ce27d2a6ccb13a934628cb8558adfbf50231b294d51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2761a21abc5248ef96c4ce27d2a6ccb13a934628cb8558adfbf50231b294d51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2761a21abc5248ef96c4ce27d2a6ccb13a934628cb8558adfbf50231b294d51"
    sha256 cellar: :any_skip_relocation, ventura:        "2b439f95e50d7222492f98058be32dcbba251745fcb559847585f045b6818651"
    sha256 cellar: :any_skip_relocation, monterey:       "2b439f95e50d7222492f98058be32dcbba251745fcb559847585f045b6818651"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b439f95e50d7222492f98058be32dcbba251745fcb559847585f045b6818651"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed4c0960a0cc0af7ae09ba1ee4cbc45d2f1703ee85319cf2b209f17103f16441"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-trimpath", "-ldflags", "-w -s", "-o", bin/name
  end

  test do
    text = "Hello Homebrew!"
    task = "hello"
    (testpath/"Runfile").write <<~EOS
      #{task}:
        echo #{text}
    EOS
    assert_equal text, shell_output("#{bin}/#{name} #{task}").chomp
  end
end
