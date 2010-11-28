class RecurringEntry < ActiveRecord::Base
  belongs_to :user
  has_many :entries

  validates :period,:presence => true, :inclusion =>
    { :in => %w{daily weekly monthly yearly} }
  validates :wday, :presence => false, :numericality => true
  validates :mday, :presence => false, :numericality => true
  validates :month, :presence => false, :numericality => true
  validates :content, :presence => true, :length =>
    {:minimum => 1, :maximum => 1000}
end
