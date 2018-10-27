class OvertimeCalculator
  def initialize(punchcards:)
    @punchcards = punchcards
  end

  def calculate
    cards_grouped_by_week = punchcards.group_by(&:week)

    cards_grouped_by_week.each do |grouping|
      hours_worked_this_week_so_far = 0
      grouping[1].each do |punchcard|

        punchcard.hours_worked.times do
          if hours_worked_this_week_so_far < 40
            punchcard.regular_hours += 1
            hours_worked_this_week_so_far += 1
          else
            punchcard.classification == "w-2" ? punchcard.overtime_hours += 1 : punchcard.regular_hours += 1
          end
        end
      end
    end
  end

  private

  attr_accessor :punchcards
end
