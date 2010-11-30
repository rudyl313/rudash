module RecurringEntriesHelper
  def day_options
    (0..6).to_a.map { |i| [week_day(i),i] }
  end

  def month_options
    (1..12).to_a.map { |i| [month_string(i),i] }
  end

  def month_string(num)
    arr = [nil,"January","February","March","April","May","June","July","August","September","October","November","December"]
    arr[num]
  end
end
