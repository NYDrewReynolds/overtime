class Punchcard
  def initialize(day:, week:, hours_worked:)
    @day = day
    @week = week
    @hours_worked = hours_worked
    @regular_hours = 0
    @overtime_hours = 0
  end

  attr_reader :day, :week, :hours_worked
  attr_accessor :regular_hours, :overtime_hours

  def hours
    [regular_hours, overtime_hours]
  end
end
