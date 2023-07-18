class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/kubecfg/kubecfg"
  url "https://github.com/kubecfg/kubecfg/archive/v0.31.1.tar.gz"
  sha256 "151d8cfb1fbba8bfde97fba4635c161db33ac94d87661567ecc27ebab1d18bba"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f6e55d9603f9a8befe3ceba7a5c54eeb3e3575d4c41a192e316196ac658fca5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e27ffb452eac18ba82b1cb82d047af0ddba9a63554e0d7f75fa4a5939e157ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf2ad391560cb20da6252e1c9ddee219b8202ae91f67871de3a79fe281c42fa5"
    sha256 cellar: :any_skip_relocation, ventura:        "3e41e802a62203e5252b692628a3a548271949445041610b3212c3de9c23200d"
    sha256 cellar: :any_skip_relocation, monterey:       "074c853f9edebd9261292c69a4606e603a2072f5af3a93d897589ac8cbbfe79f"
    sha256 cellar: :any_skip_relocation, big_sur:        "d31c16c11870a7f80e5475b750177142598f92130dedd9bba1abd4be43360d06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e3e3521804b1aa8d27b5bc4d2cbeb9bcdab5a06c80ffc9d88153f0bc34d4ffa"
  end

  depends_on "go" => :build

  def install
    system "make", "VERSION=v#{version}"
    bin.install "kubecfg"
    pkgshare.install Pathname("examples").children
    pkgshare.install Pathname("testdata").children

    generate_completions_from_executable(bin/"kubecfg", "completion", "--shell")
  end

  test do
    system bin/"kubecfg", "show", "--alpha", pkgshare/"kubecfg_test.jsonnet"
  end
end
