class User < ActiveRecord::Base
  acts_as_authentic

  has_many :entries
  has_many :recurring_entries

  validates :login, :presence => true, :length => {:minimum => 1, :maximum => 20}

  def self.permissions
    self.first.attributes.map {|key, val| key}.select {|a| a[-10..-1] == "permission"}
  end
end
