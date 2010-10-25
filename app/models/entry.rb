class Entry < ActiveRecord::Base
  validates_presence_of :content, :due_date
end
