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

          if regular_hours_worked_this_week_so_far < 40
            if punchcard.regular_hours < overtime_threshold
              punchcard.regular_hours += 1
              self.regular_hours_worked_this_week_so_far += 1
            else
              punchcard.overtime_hours += 1
            end
          else
            punchcard.overtime_hours += 1
          end

        else

          if hours_worked_this_week_so_far < 40
            punchcard.regular_hours += 1
          elsif hours_worked_this_week_so_far >= 40
            punchcard.log_hours_over_40(1)
          end

        end

        self.hours_worked_this_week_so_far += 1
        punchcard.hours_worked -= 1
      end

    end
  end
end
