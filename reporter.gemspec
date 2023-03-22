require_relative "lib/reporter/version"

Gem::Specification.new do |spec|
  spec.name        = "reporter"
  spec.version     = Reporter::VERSION
  spec.authors     = ["Eugene Stepanov"]
  spec.email       = ["antynitr@gmail.com"]
  spec.homepage    = "https://github.com/Nitr/reporter"
  spec.summary     = "An easy way to generate reports in different formats."
  spec.description = "An easy way to generate reports in different formats."
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Nitr/reporter"
 # spec.metadata["changelog_uri"] = "https://dummy.ru"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.4.2"
  spec.add_dependency "pagy", ">= 5.0"
end
