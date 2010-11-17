class Entry < ActiveRecord::Base
  belongs_to :user
  validates :content, :presence => true, :length => {:minimum => 1, :maximum => 1000}
  validates :due_date, :presence => true

  def self.generate_order_time
    Time.now.strftime("%I:%M%p")
  end
end
