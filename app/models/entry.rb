class Entry < ActiveRecord::Base
  belongs_to :user
  belongs_to :recurring_entry

  validates :content, :presence => true, :length => {:minimum => 1, :maximum => 1000}
  validates :due_date, :presence => true
  validates :order_time, :presence => true

  def self.generate_order_time
    Time.now.strftime("%I:%M%p")
  end

  def self.order_time_to_be_after(after_id,entry_id,due_date)
    entry = find(entry_id.to_i)
    if entry.due_time
      order_time = entry.due_time
    else
      if after_id == "first"
        first_entry = Entry.where("due_date = ?",due_date.to_date).order(:order_time).first
        if first_entry
          order_time = first_entry.order_time - 2.minutes
        else
          order_time = self.generate_order_time
        end
      else
        after_entry = Entry.find(after_id.to_i)
        next_entry = Entry.where("order_time > ?",after_entry.order_time).
          order(:order_time).first
        if next_entry
          order_time = after_entry.order_time +
            (next_entry.order_time - after_entry.order_time)/2
        else
          order_time = after_entry.order_time + 2.minutes
        end
      end
    end
    order_time
  end
end
