class CreateAwardedPoints < ActiveRecord::Migration
  def self.up
    create_table :awarded_points do |t|
      t.references :sash
      t.string :category
      t.integer :points,  :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :awarded_points
  end
end
