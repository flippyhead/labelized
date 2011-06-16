guard 'rspec', :cli => '--color --format nested --fail-fast', :all_on_start => false, :all_after_pass => false, :notification => true, :keep_failed => false do
  watch(/^spec\/(.*)_spec.rb/)
  watch(/^lib\/(.*)\.rb/)                              { |m| "spec/#{m[1]}_spec.rb" }
  watch(/^spec\/spec_helper.rb/)                       { "spec" }
  #watch(/^app\/(.*)\.rb/)                              { |m| "spec/#{m[1]}_spec.rb" }
  # watch(/^config\/routes.rb/)                          { "spec/routing" }
  # watch(/^app\/controllers\/application_controller.rb/) { "spec/controllers" }
  # watch(/^spec\/factories.rb/)                         { "spec/models" }
end