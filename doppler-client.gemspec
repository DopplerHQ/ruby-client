lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "doppler/version"

Gem::Specification.new do |spec|
  spec.name          = "doppler-client"
  spec.version       = Doppler::VERSION
  spec.authors       = ["Doppler Team"]
  spec.email         = "brian@doppler.market"

  spec.summary       = "The official Doppler Ruby client."
  spec.description   = "Doppler helps you manage your API keys and secrets across all your projects. See https://doppler.market for details."
  spec.homepage      = "https://github.com/DopplerHQ/ruby-client"
  spec.licenses      = "Apache-2.0"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "hitimes", "~> 1.3"
end
