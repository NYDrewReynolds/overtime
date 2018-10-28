class PunchcardsForWeek
  attr_accessor :punchcards, :hours_worked_this_week_so_far, :regular_hours_worked_this_week_so_far

  def initialize(punchcards:)
    @punchcards = punchcards
    @hours_worked_this_week_so_far = 0
    @regular_hours_worked_this_week_so_far = 0
  end

  def calculate_hours(overtime_threshold:)
    punchcards.each do |punchcard|
      until punchcard.hours_worked == 0

        if overtime_threshold
          reached_40_regular_hours ?  punchcard.add_overtime_hours(1) : punchcard.log_hour(overtime_threshold, self)
        else
          hours_worked_this_week_so_far < 40 ?  punchcard.add_regular_hours(1) : punchcard.log_hours_over_40(1)
        end

        self.hours_worked_this_week_so_far += 1
        punchcard.hours_worked -= 1
      end

    end
  end

  def reached_40_regular_hours
    regular_hours_worked_this_week_so_far >= 40
  end

  def worked_longer_than_daily_overtime_threshold(punchcard, overtime_threshold)
    punchcard.hours_worked > overtime_threshold
  end

  def log_regular_hour
    self.regular_hours_worked_this_week_so_far += 1
  end
end
