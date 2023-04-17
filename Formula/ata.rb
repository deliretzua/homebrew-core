class Ata < Formula
  desc "ChatGPT in the terminal"
  homepage "https://github.com/rikhuijzer/ata"
  url "https://github.com/rikhuijzer/ata/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "6e4a54193f9d875701535f7eaf36225d9b4ec47caf6234827291e6fa6a72951f"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "ata")
  end

  test do
    system "#{bin}/ata", "--version"

    config_file = testpath/"config/ata.toml"
    config_file.write <<~EOS
      api_key = "<YOUR SECRET API KEY>"
      model = "gpt-3.5-turbo"
      max_tokens = 2048
      temperature = 0.8
    EOS

    IO.popen("#{bin}/ata --config #{config_file} 2>&1", "r+") do |pipe|
      assert_match "Ask the Terminal Anything", pipe.gets.chomp
      assert_empty pipe.gets.chomp
      assert_match "model: gpt-3.5-turbo", pipe.gets.chomp
      assert_match "max_tokens: 2048", pipe.gets.chomp
      assert_match "temperature: 0.8", pipe.gets.chomp
      assert_empty pipe.gets.chomp
      assert_match "Prompt: ", pipe.gets.chomp
      pipe.puts "Hello\n"
      pipe.flush
      assert_empty pipe.gets.chomp
      assert_match "Error:", pipe.gets.chomp
    end
  end
end
