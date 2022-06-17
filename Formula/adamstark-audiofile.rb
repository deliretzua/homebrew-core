class AdamstarkAudiofile < Formula
  desc "C++ Audio File Library by Adam Stark"
  homepage "https://github.com/adamstark/AudioFile"
  url "https://github.com/adamstark/AudioFile/archive/refs/tags/1.1.0.tar.gz"
  sha256 "7546e39ca17ac09c653f46bfecce4a9936fae3784209ad53094915c78792a327"
  license "MIT"

  def install
    include.install "AudioFile.h"
  end

  test do
    (testpath/"audiofile.cc").write <<~EOS
      #include "AudioFile.h"
      int main(int argc, char* *argv) {
        AudioFile<double> audioFile;
        AudioFile<double>::AudioBuffer abuf;
        return 0;
      }
    EOS

    system ENV.cxx, "-std=c++11", \
           "-o", "audiofile", \
           "audiofile.cc", \
            "-L", include.to_s
    system "./audiofile"
  end
end
