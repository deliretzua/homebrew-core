class Dovecot < Formula
  desc "IMAP/POP3 server"
  homepage "https://dovecot.org/"
  url "https://dovecot.org/releases/2.3/dovecot-2.3.14.tar.gz"
  sha256 "c8b3d7f3af1e558a3ff0f970309d4013a4d3ce136f8c02a53a3b05f345b9a34a"
  license all_of: ["BSD-3-Clause", "LGPL-2.1-or-later", "MIT", "Unicode-DFS-2016", :public_domain]

  livecheck do
    url "https://dovecot.org/download"
    regex(/href=.*?dovecot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "6ad349637be542b74629d22b176f95463ce76b2a2222399eca131e7a32a5f153"
    sha256 big_sur:       "8a4135867d76e1483351627346542c4828aaac3c06b7f3b82a557bf38774c689"
    sha256 catalina:      "55c17feff666226130fb4b8bd47416bfdb22cc6ca7853a02f7a6f6d25416f440"
    sha256 mojave:        "5733ac6559b0270d187eba750314195c0c0e469dbeb5541d688ac06ed2db8339"
  end

  depends_on "openssl@1.1"
  uses_from_macos "bzip2"
  uses_from_macos "sqlite"

  resource "pigeonhole" do
    url "https://pigeonhole.dovecot.org/releases/2.3/dovecot-2.3-pigeonhole-0.5.14.tar.gz"
    sha256 "68ca0f78a3caa6b090a469f45c395c44cf16da8fcb3345755b1ca436c9ffb2d2"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --libexecdir=#{libexec}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-bzlib
      --with-pam
      --with-sqlite
      --with-ssl=openssl
      --with-zlib
    ]

    system "./configure", *args
    system "make", "install"

    resource("pigeonhole").stage do
      args = %W[
        --disable-dependency-tracking
        --with-dovecot=#{lib}/dovecot
        --prefix=#{prefix}
      ]

      system "./configure", *args
      system "make"
      system "make", "install"
    end
  end

  def caveats
    <<~EOS
      For Dovecot to work, you may need to create a dovecot user
      and group depending on your configuration file options.
    EOS
  end

  plist_options startup: true

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>KeepAlive</key>
          <false/>
          <key>RunAtLoad</key>
          <true/>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_sbin}/dovecot</string>
            <string>-F</string>
          </array>
          <key>StandardErrorPath</key>
          <string>#{var}/log/dovecot/dovecot.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/dovecot/dovecot.log</string>
          <key>SoftResourceLimits</key>
          <dict>
          <key>NumberOfFiles</key>
          <integer>1000</integer>
          </dict>
          <key>HardResourceLimits</key>
          <dict>
          <key>NumberOfFiles</key>
          <integer>1024</integer>
          </dict>
        </dict>
      </plist>
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/dovecot --version")
  end
end
