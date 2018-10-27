class OvertimeCalculator
  def initialize(punchcards:, overtime_threshold: nil)
    @punchcards = punchcards
    @overtime_threshold = overtime_threshold
  end

  def calculate
    cards_grouped_by_week = punchcards.group_by(&:week)

    cards_grouped_by_week.each do |grouping|
      hours_worked_this_week_so_far = 0
      grouping[1].each do |punchcard|
        hours = Array.new(punchcard.hours_worked, 1)

        while hours_worked_this_week_so_far < 40 && !hours.empty?
          if overtime_threshold && punchcard.regular_hours < overtime_threshold
            punchcard.regular_hours += hours.pop
          elsif !overtime_threshold
            punchcard.regular_hours += hours.pop
          else
            punchcard.overtime_hours += hours.pop
          end
            hours_worked_this_week_so_far += 1
        end

        if hours_worked_this_week_so_far >= 40
          punchcard.log_hours_over_40(punchcard.hours_worked - punchcard.regular_hours)
        end
      end
    end
  end

  private

  attr_accessor :punchcards, :overtime_threshold
end
