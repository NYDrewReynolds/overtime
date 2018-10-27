class Punchcard
  def initialize(day:, week:, hours_worked:, classification: "w-2")
    @day = day
    @week = week
    @hours_worked = hours_worked
    @classification = classification
    @regular_hours = 0
    @overtime_hours = 0
  end

  attr_reader :day, :week, :hours_worked, :classification
  attr_accessor :regular_hours, :overtime_hours

  def w2?
    classification == "w-2"
  end

  def log_hours_over_40(hours)
    w2? ? add_overtime_hours(hours) : add_regular_hours(hours)
  end

  def add_overtime_hours(hours)
    self.overtime_hours += hours
  end

  def add_regular_hours(hours)
    self.regular_hours += hours
  end

  def hours
    [regular_hours, overtime_hours]
  end
end
