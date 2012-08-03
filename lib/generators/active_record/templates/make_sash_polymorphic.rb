class MakeSashPolymorphic < ActiveRecord::Migration
  def self.up
    change_table :sashes do |t|
      t.references :sashable, :polymorphic => true
    end
  end

  def self.down
    remove_column :sashes, :sashable_id
    remove_column :sashes, :sashable_type
  end
end
