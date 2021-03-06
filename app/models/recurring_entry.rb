class RecurringEntry < ActiveRecord::Base
  belongs_to :user
  has_many :entries, :dependent => :destroy

  validates :period,:presence => true, :inclusion => { :in => ["daily","weekdaily","weekly" ,"monthly","yearly"] }
  validates :content, :presence => true, :length =>
    {:minimum => 1, :maximum => 1000}

  scope :daily, where(:period => "daily")
  scope :weekdaily, where(:period => "weekdaily")
  scope :weekly, lambda {|dates|
    where(:period => "weekly", :wday => dates.map(&:wday).uniq.sort!)
  }
  scope :monthly, lambda {|dates|
    where(:period => "monthly", :mday => dates.map(&:mday).uniq.sort!)
  }
  scope :yearly, lambda {|dates|
    where(:period => "yearly", :mday => dates.map(&:mday),
          :month => dates.map(&:month))
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

    self.weekdaily.for_user(user).each do |rentry|
      dates.reject{|date| [0,6].include?(date.wday)}.each do |date|
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
      dates.select{|d| d.mday == rentry.mday &&
        d.month == rentry.month}.each do |date|
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
    entry.order_time = rentry.due_time
    entry.order_time ||= Entry.generate_order_time
    entry.save!
  end
end
