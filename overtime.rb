require_relative "./punchcards_for_week"

class OvertimeCalculator
  def initialize(punchcards:, overtime_threshold: nil)
    @punchcards = punchcards
    @overtime_threshold = overtime_threshold
  end

  def calculate
    cards_grouped_by_week = punchcards.group_by(&:week)

    punchcards_for_week = cards_grouped_by_week.map do |cards|
      PunchcardsForWeek.new(punchcards: cards[1])
    end

    punchcards_for_week.each { |cards_for_week| cards_for_week.calculate_hours(overtime_threshold: overtime_threshold) }

  end

  private

  attr_accessor :punchcards, :overtime_threshold
end
