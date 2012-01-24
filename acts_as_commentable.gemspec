$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "acts_as_commentable/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "acts_as_commentable"
  s.version     = ActsAsCommentable::VERSION
  s.authors     = ["Cosmin Radoi, Jack Dempsey, Xelipe, Chris Eppstein"]
  s.email       = ["unknown@juixe.com"]
  s.homepage    = "https://github.com/yenihayat/acts_as_commentable"
  s.summary     = "Plugin/gem that provides comment functionality"
  s.description = "Plugin/gem that provides comment functionality"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.0"
  # s.add_dependency "jquery-rails"

  #s.add_development_dependency "sqlite3"
end
