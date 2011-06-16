require 'active_support'

class CreateModels < ActiveRecord::Migration
  def self.up
    create_table :things do |t|
      t.string :name
    end
  end
end