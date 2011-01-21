class CreateSources < ActiveRecord::Migration
  def self.up
    create_table :sources do |t|
      t.integer :user_id
      t.string :source_type, :null => false
      t.string :title
      t.string :author
      t.string :url
      t.timestamps
    end
  end

  def self.down
    drop_table :sources
  end
end
