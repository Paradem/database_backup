require_relative "lib/database_backup/version"

Gem::Specification.new do |spec|
  spec.name = "database_backup"
  spec.version = DatabaseBackup::VERSION
  spec.authors = ["Kevin Pratt"]
  spec.email = ["kevin@paradem.co"]
  spec.homepage = "https://paradem.co"
  spec.summary = "https://paradem.co"
  spec.description = "https://paradem.co"
  spec.license = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "https://paradem.co"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/paradem/database_backup"
  spec.metadata["changelog_uri"] = "https://github.com/paradem/database_backup/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.1.2"
  spec.add_dependency "aws-sdk-s3"
end
