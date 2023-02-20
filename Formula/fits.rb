class Fits < Formula
  desc "File Information Tool Set"
  homepage "https://projects.iq.harvard.edu/fits"
  url "https://github.com/harvard-lts/fits/releases/download/1.6.0/fits-1.6.0.zip"
  sha256 "32e436effe7251c5b067ec3f02321d5baf4944b3f0d1010fb8ec42039d9e3b73"
  license "LGPL-2.1-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, all: "cd4ac00bed12a2221f0f5b43e13c6605bb53c8cbcb4f518beec8eebb8bef820f"
  end

  depends_on "exiftool"
  depends_on "libmediainfo"
  # Installs pre-built .so files linking to system zlib
  depends_on :macos
  depends_on "openjdk"

  def install
    # Remove Windows, PPC, and 32-bit Linux binaries
    %w[macho elf exe dylib].each do |ext|
      (buildpath/"tools/exiftool/perl/t/images/EXE.#{ext}").unlink
    end

    # Remove Windows-only directories
    %w[exiftool/windows file_utility_windows mediainfo/windows].each do |dir|
      (buildpath/"tools"/dir).rmtree
    end

    libexec.install "lib", "tools", "xml", *buildpath.glob("*.properties")

    inreplace "fits-env.sh" do |s|
      s.gsub!(/^FITS_HOME=.*/, "FITS_HOME=#{libexec}")
      s.gsub! "${FITS_HOME}/lib", "#{libexec}/lib"
    end

    inreplace %w[fits.sh fits-ngserver.sh],
              %r{\$\(dirname .*\)/fits-env\.sh}, "#{libexec}/fits-env.sh"

    # fits-env.sh is a helper script that sets up environment
    # variables, so we want to tuck this away in libexec
    libexec.install "fits-env.sh"
    (libexec/"bin").install %w[fits.sh fits-ngserver.sh]
    (bin/"fits").write_env_script libexec/"bin/fits.sh", Language::Java.overridable_java_home_env
    (bin/"fits-ngserver").write_env_script libexec/"bin/fits.sh", Language::Java.overridable_java_home_env

    # Replace universal binaries with their native slices (for `libmediainfo.dylib`)
    deuniversalize_machos
  end

  test do
    cp test_fixtures("test.mp3"), testpath
    assert_match 'mimetype="audio/mpeg"', shell_output("#{bin}/fits -i test.mp3")
  end
end
