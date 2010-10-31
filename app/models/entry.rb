class Entry < ActiveRecord::Base
  belongs_to :user

  scope :for_date, lambda{|date| where("due_date = ?",date) }

  validates :content, :presence => true, :length => {:minimum => 1, :maximum => 1000}
  validates :due_date, :presence => true
end
