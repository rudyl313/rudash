module EntriesHelper
  def week_day(num)
    days = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    days[num]
  end

  def short_month(num)
    months = [nil,"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
    months[num]
  end

  def date_label(date)
    wday = date.wday
    (wday == 0) ? "#{week_day(wday)} (#{short_month(date.month)} #{date.day})" : week_day(wday)
  end
end
