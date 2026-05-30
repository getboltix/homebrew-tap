class Boltix < Formula
  desc "CLI generator — dynamic command surface from OpenAPI and GraphQL schemas"
  homepage "https://github.com/getboltix/boltix-cli"
  version "0.0.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getboltix/boltix-cli/releases/download/v0.0.8/fern-cli-sdk-aarch64-apple-darwin.tar.gz"
      sha256 "7936ac03bafe863d2c7fff9801056e2bd8e71b1c8cc43701ee808f476734fec2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getboltix/boltix-cli/releases/download/v0.0.8/fern-cli-sdk-x86_64-apple-darwin.tar.gz"
      sha256 "a351a6254c51dada12eea7dd351544d1694ce6d9f8ff6aebd710fad6369eeecb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getboltix/boltix-cli/releases/download/v0.0.8/fern-cli-sdk-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "20e5e0704b02f3551dcea924aeeec07e0ece2c78f0fdcb64b15b4338f4ee1e15"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getboltix/boltix-cli/releases/download/v0.0.8/fern-cli-sdk-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "252c72a158a40b5ae3744c2c8081d8afb00191a95f9902070ea1560c2596cae4"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "boltix" if OS.mac? && Hardware::CPU.arm?
    bin.install "boltix" if OS.mac? && Hardware::CPU.intel?
    bin.install "boltix" if OS.linux? && Hardware::CPU.arm?
    bin.install "boltix" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
