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

  scope :daily, where(:period => "daily")
  scope :weekly, lambda {|dates|
    where(:period => "weekly", :wday => dates.map(&:wday).uniq.sort!)
  }
  scope :monthly, lambda {|dates|
    where(:period => "weekly", :mday => dates.map(&:mday).uniq.sort!)
  }
  scope :yearly, lambda {|dates|
    where(:period => "yearly", :due_date => dates)
  }
  scope :for_user, lambda{|user|
    where(:user_id => user.id)
  }


  def self.generate_entries(dates,user)
    self.daily.for_user(user).each do |rentry|
      dates.each do |date|
        update_entry(rentry,date)
      end
    end

    self.weekly(dates).for_user(user).each do |rentry|
      dates.select{|d| d.wday == rentry.wday}.each do |date|
        update_entry(rentry,date)
      end
    end

    self.monthly(dates).for_user(user).each do |rentry|
      dates.select{|d| d.mday == rentry.mday}.each do |date|
        update_entry(rentry,date)
      end
    end

    self.yearly(dates).for_user(user).each do |rentry|
      dates.select{|d| rentry.due_date = d}.each do |date|
        update_entry(rentry,date)
      end
    end
  end

  def self.update_entry(rentry,date)
    entry = rentry.entries.where(:due_date => date).first
    entry ||= rentry.entries.new(:due_date => date)
    entry.content = rentry.content
    entry.due_time = rentry.due_time
    entry.user_id = rentry.user_id
    entry.order_time ||= Entry.generate_order_time
    entry.save!
  end
end
