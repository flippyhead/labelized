# require 'rubygems'
# require 'bundler'
# 
# begin
#   Bundler.setup(:default, :development)
# rescue Bundler::BundlerError => e
#   $stderr.puts e.message
#   $stderr.puts "Run `bundle install` to install missing gems"
#   exit e.status_code
# end
# 
# require 'spec'
# 
# $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
# $LOAD_PATH.unshift(File.dirname(__FILE__))
# 
# require 'labelized'


$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'labelized'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
end

require 'active_record'

dbconf = YAML::load(File.open(File.expand_path(File.dirname(__FILE__) + '/db/config.yml')))
ActiveRecord::Base.establish_connection(dbconf) 

# do a quick pseudo migration. This should only get executed on the first run
ActiveRecord::Base.connection.create_table(:things) do |t|
  t.column :name, :string
  t.column :root_id, :integer
end

ActiveRecord::Base.connection.create_table(:roots) do |t|
  t.column :name, :string
end

ActiveRecord::Base.connection.create_table(:labels) do |t|
  t.column :name, :string
  t.column :root_id, :integer
  t.column :label_set_id, :integer
end

ActiveRecord::Base.connection.create_table(:labelings) do |t|
  t.column :label_id, :integer
  t.column :labeled_id, :integer
  t.column :labeled_type, :string
end

ActiveRecord::Base.connection.create_table(:label_sets) do |t|
  t.column :name, :string
  t.column :root_id, :integer
end

# ActiveRecord::Base.logger = Logger.new(File.open('log/database.log', 'a')) 
# MigrationsXX.migrate(:up) 


