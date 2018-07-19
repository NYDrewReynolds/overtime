class OvertimeCalculator
  def initialize(punchcards:)
    @punchcards = punchcards
  end

  def calculate
    punchcards.each do |punchcard|
      punchcard.regular_hours = 1
      punchcard.overtime_hours = 2
    end
  end

  private

  attr_accessor :punchcards
end
