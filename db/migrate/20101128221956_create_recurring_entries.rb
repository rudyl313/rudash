class CreateRecurringEntries < ActiveRecord::Migration
  def self.up
    create_table :recurring_entries do |t|
      t.string :period
      t.integer :wday
      t.integer :mday
      t.integer :month
      t.time :due_time
      t.string :content
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :recurring_entries
  end
end
