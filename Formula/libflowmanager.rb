class Libflowmanager < Formula
  desc "Flow-based measurement tasks with packet-based inputs"
  homepage "https://github.com/LibtraceTeam/libflowmanager"
  url "https://github.com/LibtraceTeam/libflowmanager/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "ab60c9c9611488e51c14b6e3870f91a191236dced12f0ed16a58cdd2c08ee74f"
  license "LGPL-3.0-or-later"
  revision 2

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d73a9c5834f5cceceefda2547bebb79ab267df8244af23525a0b9347127c6ce1"
    sha256 cellar: :any,                 arm64_big_sur:  "0ee5ac027b4b6147a242372d436af6c842a715d8eda53a12520412bbbe68a833"
    sha256 cellar: :any,                 monterey:       "3ba52841763b302ad36c51d5e1f48bd54491ad1c735ab08ab1f1fc010b6b7807"
    sha256 cellar: :any,                 big_sur:        "a72f919e29358d8c3698ba0b4677b4c46effef119591dc38b6e99c244731329e"
    sha256 cellar: :any,                 catalina:       "3062037389000f22d292506d3129dd99575bbc9cb73d6a1e65483c2935e35329"
    sha256 cellar: :any,                 mojave:         "5358da08e9444be464325d1b2745b808a26916b79a3eec2810a52068fc2ad7fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ee9bff7bfd92e6794746f74634273457b92fbb7c94934cea4c07d3f0d9c08e7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libtrace"

  # Fix: tcp_reorder.c:74:30: error: ‘UINT32_MAX’ undeclared (first use in this function)
  # Remove in the next release
  patch do
    url "https://github.com/LibtraceTeam/libflowmanager/commit/a60a04a3b4a12faf48854b34908f9db0c4f080b0.patch?full_index=1"
    sha256 "15d93f863374eff428c69e6e1733bdc861c831714f8d7d7c1323ebf1b9ba9a4c"
  end

  def install
    system "autoreconf", "-ivf"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
