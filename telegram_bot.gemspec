# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'telegram_bot/version'

Gem::Specification.new do |spec|
  spec.name          = "telegram_bot"
  spec.version       = TelegramBot::VERSION
  spec.authors       = ["José Tomás Albornoz"]
  spec.email         = ["jojo@eljojo.net"]
  spec.summary       = %q{Simple client for Telegram's Bot API}
  spec.description   = %q{Still in development. Simple client for Telegram's Bot API}
  spec.homepage      = "https://github.com/eljojo/telegram_bot"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "excon", ">= 0.30.0"
  spec.add_dependency "virtus", ">= 1.0.0"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.10"
  spec.add_development_dependency "vcr", "~> 4.0"
end
