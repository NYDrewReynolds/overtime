class Punchcard
  def initialize(day:, week:, hours_worked:, classification: "w-2")
    @day = day
    @week = week
    @hours_worked = hours_worked
    @classification = classification
    @regular_hours = 0
    @overtime_hours = 0
  end

  attr_reader :day, :week,  :classification
  attr_accessor :regular_hours, :overtime_hours, :hours_worked

  def w2?
    classification == "w-2"
  end

  def log_hours_over_40(hours)
    w2? ? add_overtime_hours(hours) : add_regular_hours(hours)
  end

  def log_hour(overtime_threshold, punchcards_for_week)
    worked_longer_than_daily_overtime_threshold?(overtime_threshold) ?
      add_overtime_hours(1) :
      add_regular_hours(1, punchcards_for_week: punchcards_for_week)
  end

  def add_overtime_hours(hours)
    self.overtime_hours += hours
  end

  def add_regular_hours(hours, punchcards_for_week: nil)
    self.regular_hours += hours

    if punchcards_for_week
      punchcards_for_week.log_regular_hour
    end
  end

  def worked_longer_than_daily_overtime_threshold?(threshold)
    hours_worked > threshold
  end

  def hours
    [regular_hours, overtime_hours]
  end

end
