class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
      t.string :content
      t.date :due_date
      t.time :due_time
      t.string :type

      t.timestamps
    end
  end

  def self.down
    drop_table :entries
  end
end
