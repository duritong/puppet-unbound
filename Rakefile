require 'bundler'
Bundler.require(:rake)

require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'

Rake::Task[:lint].clear
PuppetLint::RakeTask.new :lint do |config|
  config.ignore_paths = ["spec/**/*.pp", "vendor/**/*.pp"]
  config.log_format = '%{path}:%{linenumber}:%{KIND}: %{message}'
  config.disable_checks = [ "class_inherits_from_params_class", "80chars" ]
end

# use librarian-puppet to manage fixtures instead of .fixtures.yml
# offers more possibilities like explicit version management, forge downloads,...
task :librarian_spec_prep do
  sh "librarian-puppet install --path=spec/fixtures/modules/"
  pwd = Dir.pwd.strip
  unless File.directory?("#{pwd}/spec/fixtures/modules/unbound")
    # workaround for windows as symlinks are not supported with 'ln -s' in git-bash
    if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
      begin
        sh "cmd /c \"mklink /d #{pwd}\\spec\\fixtures\\modules\\unbound #{pwd}\""
      rescue Exception => e
        puts '-----------------------------------------'
        puts 'Git Bash must be started as Administrator'
        puts '-----------------------------------------'
        raise e
      end
    else
      sh "ln -s #{pwd} #{pwd}/spec/fixtures/modules/unbound"
    end
  end
end

task :spec_prep => :librarian_spec_prep

task :default => [:spec, :lint]

