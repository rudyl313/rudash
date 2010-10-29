class User < ActiveRecord::Base
  acts_as_authentic

  has_many :entries

  def self.permissions
    self.first.attributes.map {|key, val| key}.select {|a| a[-10..-1] == "permission"}
  end
end
