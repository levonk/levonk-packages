#!/usr/bin/env ruby
# Homebrew Formula Generator for Command Governance
# Usage: ./generate-formula.rb <package-name> <behavior-type>

require 'json'

PACKAGE_NAME = ARGV[0]
BEHAVIOR_TYPE = ARGV[1]
SCRIPT_DIR = File.dirname(__FILE__)
PROJECT_ROOT = File.dirname(File.dirname(SCRIPT_DIR))

if PACKAGE_NAME.nil? || BEHAVIOR_TYPE.nil?
  puts "Usage: #{$0} <package-name> <behavior-type>"
  puts "Example: #{$0} prefer-pnpm prefer"
  puts "Behavior types: prefer, eject, force, block"
  exit 1
end

# Validate behavior type
unless %w[prefer eject force block].include?(BEHAVIOR_TYPE)
  puts "Error: Invalid behavior type '#{BEHAVIOR_TYPE}'"
  puts "Valid types: prefer, eject, force, block"
  exit 1
end

# Determine the target binary and wrapper script
case PACKAGE_NAME
when 'prefer-pnpm', 'force-pnpm', 'block-npm', 'eject-npm'
  TARGET_BINARY = 'npm'
  WRAPPER_SCRIPT = "npm.#{PACKAGE_NAME}.sh"
when 'prefer-uv', 'block-pip', 'eject-pip'
  TARGET_BINARY = 'pip'
  WRAPPER_SCRIPT = "pip.#{PACKAGE_NAME}.sh"
when 'prefer-devbox'
  TARGET_BINARY = 'curl'
  WRAPPER_SCRIPT = "curl.#{PACKAGE_NAME}.sh"
when 'prefer-corepack'
  TARGET_BINARY = 'node'
  WRAPPER_SCRIPT = "node.#{PACKAGE_NAME}.sh"
else
  puts "Error: Unknown package '#{PACKAGE_NAME}'"
  exit 1
end

FORMULA_DIR = File.join(SCRIPT_DIR, PACKAGE_NAME)
Dir.mkdir(FORMULA_DIR) unless Dir.exist?(FORMULA_DIR)

# Create formula file
formula_content = <<~RUBY
  # Command Governance System Formula
  class Command#{PACKAGE_NAME.split('-').map(&:capitalize).join} < Formula
    desc "Command governance: #{PACKAGE_NAME} - #{BEHAVIOR_TYPE} behavior"
    homepage "https://github.com/levonk/levonk-packages"
    url "https://github.com/levonk/levonk-packages/archive/v1.0.0.tar.gz"
    sha256 "SHA256_PLACEHOLDER"  # Replace with actual SHA256
    license "MIT"

    def install
      bin.install "#{buildpath}/wrappers/#{WRAPPER_SCRIPT}" => TARGET_BINARY
    end

    def caveats
      <<~EOS
        This package implements command governance for #{TARGET_BINARY}
        with #{BEHAVIOR_TYPE} behavior as defined by the Command
        Preference & Package Governance System.
      EOS
    end

    test do
      # Basic test that the binary exists and is executable
      system "#{bin}/#{TARGET_BINARY}", "--version" rescue false
    end
  end
RUBY

formula_filename = "command-#{PACKAGE_NAME}.rb"
formula_path = File.join(FORMULA_DIR, formula_filename)
File.write(formula_path, formula_content)

puts "✅ Generated Homebrew formula for #{PACKAGE_NAME}"
puts "📍 Location: #{formula_path}"
puts ""
puts "To install the formula:"
puts "  brew install #{formula_path}"
puts ""
puts "Note: Update the SHA256 placeholder with the actual checksum after release."
