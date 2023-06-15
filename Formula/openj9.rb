class Openj9 < Formula
  desc "High performance, scalable, Java virtual machine"
  homepage "https://www.eclipse.org/openj9/"
  url "https://github.com/eclipse-openj9/openj9.git",
      tag:      "openj9-0.39.0",
      revision: "088b83604033f2e4f0edb2d267b1f8b2a2450e91"
  license any_of: [
    "EPL-2.0",
    "Apache-2.0",
    { "GPL-2.0-only" => { with: "Classpath-exception-2.0" } },
    { "GPL-2.0-only" => { with: "OpenJDK-assembly-exception-1.0" } },
  ]

  livecheck do
    url :stable
    regex(/^openj9-(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "5a3862c2d52d0f0e8a62904255255557647f94db2ab5c73f758113d9dbdb33d2"
    sha256 cellar: :any, arm64_big_sur:  "713c6b53761c66a26d6593da74800a6c6fe80abbfbbbc9c7ab04c6fb8296ec30"
    sha256 cellar: :any, ventura:        "56034f6d0788d93b27f5e352eb6279cdfd4e865c8c2ae7bb6574cb7ad2e575a1"
    sha256 cellar: :any, monterey:       "7982ef2d4b6e402f04311a3b52c1de29d579c024c80db2176adfc40728378e7e"
    sha256 cellar: :any, big_sur:        "5d407ef5beddbad83092b468f7e7b74f12c436d7fcb1bf0d24f07f65698c2111"
  end

  keg_only :shadowed_by_macos

  depends_on "autoconf" => :build
  depends_on "bash" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "giflib"
  depends_on "harfbuzz"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "little-cms2"

  uses_from_macos "m4" => :build
  uses_from_macos "cups"
  uses_from_macos "libffi"
  uses_from_macos "unzip"
  uses_from_macos "zip"
  uses_from_macos "zlib"

  on_linux do
    keg_only "it conflicts with openjdk"

    depends_on "alsa-lib"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxrandr"
    depends_on "libxrender"
    depends_on "libxt"
    depends_on "libxtst"
    depends_on "numactl"
  end

  on_intel do
    depends_on "nasm" => :build
  end

  # From https://github.com/eclipse-openj9/openj9/blob/openj9-#{version}/doc/build-instructions/
  # We use JDK 20 to bootstrap.
  resource "boot-jdk" do
    on_macos do
      on_arm do
        url "https://github.com/AdoptOpenJDK/semeru20-binaries/releases/download/jdk-20.0.1%2B9_openj9-0.39.0/ibm-semeru-open-jdk_aarch64_mac_20.0.1_9_openj9-0.39.0.tar.gz"
        sha256 "2d65da1e167ce21d325e546799aecd45e5a1d3e5314a5bda09f1d5bcae0a2d8f"
      end
      on_intel do
        url "https://github.com/AdoptOpenJDK/semeru20-binaries/releases/download/jdk-20.0.1%2B9_openj9-0.39.0/ibm-semeru-open-jdk_x64_mac_20.0.1_9_openj9-0.39.0.tar.gz"
        sha256 "7ec6980c124a322954b701887869a10986639c27df5add60300bdf62cf07d9e4"
      end
    end
    on_linux do
      url "https://github.com/AdoptOpenJDK/semeru20-binaries/releases/download/jdk-20.0.1%2B9_openj9-0.39.0/ibm-semeru-open-jdk_x64_linux_20.0.1_9_openj9-0.39.0.tar.gz"
      sha256 "aef46e2a06b8671369783c85a473aefd586fffb720abf654f45e4940b2c81df2"
    end
  end

  resource "omr" do
    url "https://github.com/eclipse-openj9/openj9-omr.git",
        tag:      "openj9-0.39.0",
        revision: "e4f52d2e479f7e64e092dcec573f1fae864395cb"
  end

  resource "openj9-openjdk-jdk" do
    url "https://github.com/ibmruntimes/openj9-openjdk-jdk20.git",
        tag:      "openj9-0.39.0",
        revision: "6cb177ca6cae7e0a63fccb800236019062c2690a"
  end

  def install
    openj9_files = buildpath.children
    (buildpath/"openj9").install openj9_files
    resource("openj9-openjdk-jdk").stage buildpath
    resource("omr").stage buildpath/"omr"
    boot_jdk = buildpath/"boot-jdk"
    resource("boot-jdk").stage boot_jdk
    boot_jdk /= "Contents/Home" if OS.mac?
    java_options = ENV.delete("_JAVA_OPTIONS")

    config_args = %W[
      --disable-warnings-as-errors-omr
      --disable-warnings-as-errors-openj9
      --with-boot-jdk-jvmargs=#{java_options}
      --with-boot-jdk=#{boot_jdk}
      --with-debug-level=release
      --with-jvm-variants=server
      --with-native-debug-symbols=none

      --with-vendor-bug-url=#{tap.issues_url}
      --with-vendor-name=#{tap.user}
      --with-vendor-url=#{tap.issues_url}
      --with-vendor-version-string=#{tap.user}
      --with-vendor-vm-bug-url=#{tap.issues_url}
      --with-version-build=#{revision}
      --without-version-opt
      --without-version-pre

      --with-giflib=system
      --with-harfbuzz=system
      --with-lcms=system
      --with-libjpeg=system
      --with-libpng=system
      --with-zlib=system

      --enable-ddr=no
      --enable-full-docs=no
    ]
    config_args += if OS.mac?
      %W[
        --enable-dtrace
        --with-sysroot=#{MacOS.sdk_path}
      ]
    else
      # Override hardcoded /usr/include directory when checking for numa headers
      inreplace "closed/autoconf/custom-hook.m4", "/usr/include/numa", Formula["numactl"].opt_include/"numa"

      %W[
        --with-x=#{HOMEBREW_PREFIX}
        --with-cups=#{Formula["cups"].opt_prefix}
        --with-fontconfig=#{Formula["fontconfig"].opt_prefix}
      ]
    end
    # Ref: https://github.com/eclipse-openj9/openj9/issues/13767
    # TODO: Remove once compressed refs mode is supported on Apple Silicon
    config_args << "--with-noncompressedrefs" if OS.mac? && Hardware::CPU.arm?

    ENV["CMAKE_CONFIG_TYPE"] = "Release"

    system "bash", "./configure", *config_args
    system "make", "all", "-j"

    jdk = libexec
    if OS.mac?
      libexec.install Dir["build/*/images/jdk-bundle/*"].first => "openj9.jdk"
      jdk /= "openj9.jdk/Contents/Home"
      rm jdk/"lib/src.zip"
      rm_rf Dir.glob(jdk/"**/*.dSYM")
    else
      libexec.install Dir["build/linux-x86_64-server-release/images/jdk/*"]
    end

    bin.install_symlink Dir[jdk/"bin/*"]
    include.install_symlink Dir[jdk/"include/*.h"]
    include.install_symlink Dir[jdk/"include"/OS.kernel_name.downcase/"*.h"]
    man1.install_symlink Dir[jdk/"man/man1/*"]
  end

  def caveats
    on_macos do
      <<~EOS
        For the system Java wrappers to find this JDK, symlink it with
          sudo ln -sfn #{opt_libexec}/openj9.jdk /Library/Java/JavaVirtualMachines/openj9.jdk
      EOS
    end
  end

  test do
    (testpath/"HelloWorld.java").write <<~EOS
      class HelloWorld {
        public static void main(String args[]) {
          System.out.println("Hello, world!");
        }
      }
    EOS

    system bin/"javac", "HelloWorld.java"

    assert_match "Hello, world!", shell_output("#{bin}/java HelloWorld")
  end
end
