class AddOrderTimeToEntry < ActiveRecord::Migration
  def self.up
    add_column :entries, :order_time, :time
  end

  def self.down
    remove_column :entries, :order_time
  end
end
