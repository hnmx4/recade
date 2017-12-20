require 'recade/version'

desc 'Build gem and install'
task :update do
  sh 'gem build recade.gemspec'
  sh "gem install recade-#{Recade::VERSION}.gem"
  sh 'gem cleanup'
  sh "rm recade-#{Recade::VERSION}.gem"
end

desc 'Run rspec test'
Dotenv.load('.env')
envs = {
  RECADE_SECRET_FILE: File.expand_path('secret.yml.enc'),
  SERVERSPEC_BACKEND: 'local',
  SPEC_TOOLS_HOST: 'docker',
  # SPEC_TOOLS_HOST: 'local'
}
RSpec::Core::RakeTask.new(:spec) do |t|
  envs.each { |k, v| ENV[k.to_s] = v }
  t.pattern = 'spec/*_spec.rb'
end
