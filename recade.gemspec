# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'recade/version'

Gem::Specification.new do |spec|
  spec.name          = 'recade'
  spec.version       = Recade::VERSION
  spec.licenses      = ['MIT']
  spec.authors       = ['Manaka TAKAHASHI']
  spec.email         = ['hnmnty@gmail.com']

  spec.summary       = %q{Manage DNS record as a code. For PowerDNS MySQL backend.}
  spec.description   = <<-EOF
recade is a DNS record managing tool for PowerDNS MySQL backend.
recade manage DNS record as a code.
Following functions of this tool:
- synchronize DNS records with YAML file
- dump DNS records to YAML format
  EOF
  spec.homepage      = 'www.tmanaka.net'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = ""
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'net-ssh', '~> 4.0'
  spec.add_dependency 'net-ssh-gateway', '~> 2.0'
  spec.add_dependency 'thor', '~> 0.19'
  spec.add_dependency 'reversible_cryptography', '~> 0.5'
  spec.add_dependency 'mysql2', '~> 0.4'

  spec.add_development_dependency 'bundler', '~> 0'
  spec.add_development_dependency 'rake', '~> 0'
  spec.add_development_dependency 'rspec', '~> 0'
end
