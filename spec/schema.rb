ActiveRecord::Schema.define :version => 0 do


  create_table :users, :force => true do |t|
    t.string :username
    t.integer :sash_id
    t.integer :level, :default => 0
    t.integer :points, :default => 0
    t.timestamps
  end


end
