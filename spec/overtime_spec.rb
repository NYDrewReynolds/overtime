require_relative "../punchcard"
require_relative "../overtime"

RSpec.describe OvertimeCalculator do

  describe "#calculate" do
    it "computes regular and overtime hours" do
      punchcards = [ Punchcard.new(day: 0, week: 0, hours_worked: 5),
                     Punchcard.new(day: 1, week: 0, hours_worked: 6),
                     Punchcard.new(day: 1, week: 0, hours_worked: 2),
                     Punchcard.new(day: 2, week: 0, hours_worked: 11),
                     Punchcard.new(day: 4, week: 0, hours_worked: 9),
                     Punchcard.new(day: 5, week: 0, hours_worked: 12),
                     Punchcard.new(day: 6, week: 0, hours_worked: 5, classification: 'w-2'),
                     Punchcard.new(day: 0, week: 1, hours_worked: 8)
      ]

      OvertimeCalculator.new(punchcards: punchcards).calculate

      expect(punchcards[0].hours).to eq([5, 0])
      expect(punchcards[1].hours).to eq([6, 0])
      expect(punchcards[2].hours).to eq([2, 0])
      expect(punchcards[3].hours).to eq([11, 0])
      expect(punchcards[4].hours).to eq([9, 0])
      expect(punchcards[5].hours).to eq([7, 5])
      expect(punchcards[6].hours).to eq([0, 5])
      expect(punchcards[7].hours).to eq([8, 0])
    end

    it "does not count hours if the punchcard is classified as 1099" do
      punchcards = [
        Punchcard.new(day: 0, week: 0, hours_worked: 10),  # 5
        Punchcard.new(day: 1, week: 0, hours_worked: 10),  # 5
        Punchcard.new(day: 2, week: 0, hours_worked: 10),  # 5
        Punchcard.new(day: 3, week: 0, hours_worked: 10),  # 5
        Punchcard.new(day: 4, week: 0, hours_worked: 10, classification: "1099")
      ]

      OvertimeCalculator.new(punchcards: punchcards).calculate

      expect(punchcards[4].hours).to eq([10, 0])
    end

    it "accounts for the double overtime threshold" do
      punchcards = [
        Punchcard.new(day: 0, week: 0, hours_worked: 10),
        Punchcard.new(day: 1, week: 0, hours_worked: 10),
        Punchcard.new(day: 2, week: 0, hours_worked: 10),
        Punchcard.new(day: 3, week: 0, hours_worked: 10),
        Punchcard.new(day: 4, week: 0, hours_worked: 5),
        Punchcard.new(day: 5, week: 0, hours_worked: 10),
      ]

      OvertimeCalculator.new(punchcards: punchcards, overtime_threshold: 8).calculate

      expect(punchcards[0].hours).to eq([8, 2])
      expect(punchcards[1].hours).to eq([8, 2])
      expect(punchcards[2].hours).to eq([8, 2])
      expect(punchcards[3].hours).to eq([8, 2])
      expect(punchcards[4].hours).to eq([5, 0])
      expect(punchcards[5].hours).to eq([3, 7])
    end
  end
end
