class MakeSashPolymorphic < ActiveRecord::Migration
  def self.up
    change_table :sashes do |t|
      t.references :sashable, :polymorphic => true
      t.integer :total_points, :default => 0
    end
  end

  def self.down
    remove_column :sashes, :sashable_id
    remove_column :sashes, :sashable_type
    remove_column :sashes, :total_points
  end
end
