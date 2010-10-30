class Entry < ActiveRecord::Base
  belongs_to :user
  validates :content, :presence => true, :length => {:minimum => 1, :maximum => 1000}
  validates :due_date, :presence => true
end
