class Boltix < Formula
  desc "CLI generator — dynamic command surface from OpenAPI and GraphQL schemas"
  homepage "https://github.com/getboltix/boltix-cli"
  version "0.0.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getboltix/boltix-cli/releases/download/v0.0.9/boltix-aarch64-apple-darwin.tar.gz"
      sha256 "7d4a74817b12bb30fcd06dbcd3607c26e6f5122281e98c380d8aca4e621bd674"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getboltix/boltix-cli/releases/download/v0.0.9/boltix-x86_64-apple-darwin.tar.gz"
      sha256 "8f1ec6d0e24b64bb90e47396c22c8fac4fabf894b0dacb2120f85364fd94d545"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getboltix/boltix-cli/releases/download/v0.0.9/boltix-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "bac8768378c7a18e0db13feb7435772e22d3af6f89b7a426a936647a5f2d3630"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getboltix/boltix-cli/releases/download/v0.0.9/boltix-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "877927cb642c16eb01c6a6473eaae2dc839876ec514b61bc827d1c55da19ada6"
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
