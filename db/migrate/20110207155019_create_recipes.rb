class CreateRecipes < ActiveRecord::Migration
  def self.up
    create_table :recipes do |t|
      t.string :title, :null => false
      t.string :author
      t.integer :user_id, :null => false
      t.integer :source_id
      t.text :summary
      t.text :ingredients
      t.text :how_to_make
      t.integer :serves
      t.timestamps
    end
  end

  def self.down
    drop_table :recipes
  end
end
