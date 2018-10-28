require_relative "../punchcard"
require_relative "../punchcards_for_week"

RSpec.describe Punchcard do
  describe "#w2?" do
    it "returns true if the classification is w-2" do
      punchcard = Punchcard.new(day: 0, week: 0, hours_worked: 10, classification: "w-2")
      expect(punchcard.w2?).to eq true
    end

    it "returns false if the classification is not w-2" do
      punchcard = Punchcard.new(day: 0, week: 0, hours_worked: 10, classification: "1099")
      expect(punchcard.w2?).to eq false
    end
  end

  describe "#log_hours_over_40" do
    context "classification is w-2" do
      punchcard = Punchcard.new(day: 0, week: 0, hours_worked: 10, classification: "w-2")

      it "adds overtime hours" do
        punchcard.log_hours_over_40(20)
        expect(punchcard.overtime_hours).to eq 20
      end
    end

    context "classification is 1099" do
      punchcard = Punchcard.new(day: 0, week: 0, hours_worked: 10, classification: "1099")

      it "adds regular hours" do
        punchcard.log_hours_over_40(20)
        expect(punchcard.overtime_hours).to eq 0
        expect(punchcard.regular_hours).to eq 20
      end
    end
  end

  describe "#log_hour" do
    context "worked longer than the daily overtime threshold" do
      punchcard = Punchcard.new(day: 0, week: 0, hours_worked: 10, classification: "w-2")

      it "adds overtime hours" do
        expect(punchcard).to receive(:add_overtime_hours).with(1)
        punchcard.log_hour(8, [])
      end
    end

    context "have NOT worked longer than the daily overtime threshold" do
      punchcard = Punchcard.new(day: 0, week: 0, hours_worked: 1, classification: "w-2")

      it "adds regular hours" do
        expect(punchcard).to receive(:add_regular_hours)
        punchcard.log_hour(8, PunchcardsForWeek.new(punchcards: []))
      end
    end
  end

  describe "#add_overtime_hours" do
    it "adds the specified number of overtime hours" do
      punchcard = Punchcard.new(day: 0, week: 0, hours_worked: 1, classification: "w-2")
      punchcard.add_overtime_hours(2)

      expect(punchcard.overtime_hours).to eq 2
    end
  end

  describe "#add_regular_hours" do
    context "punchcards_for_week is supplied" do
      it "logs an hour to the punchcards_for_week" do
        punchcard = Punchcard.new(day: 0, week: 0, hours_worked: 1, classification: "w-2")

        punchcards_for_week = PunchcardsForWeek.new(punchcards: [])
        expect(punchcards_for_week).to receive(:log_regular_hour)

        punchcard.add_regular_hours(2, punchcards_for_week: punchcards_for_week)
      end
    end

    it "adds the specified number of overtime hours" do
      punchcard = Punchcard.new(day: 0, week: 0, hours_worked: 1, classification: "w-2")
      punchcard.add_regular_hours(2)

      expect(punchcard.regular_hours).to eq 2
    end
  end

  describe "worked_longer_than_daily_overtime_threshold?" do
    it "returns true if the punchcard's hours worked is greater than the provided threshold" do
      punchcard = Punchcard.new(day: 0, week: 0, hours_worked: 10, classification: "w-2")

      expect(punchcard.worked_longer_than_daily_overtime_threshold?(8)).to eq true
    end

    it "returns false if the punchcard's hours worked is less than the provided threshold" do
      punchcard = Punchcard.new(day: 0, week: 0, hours_worked: 2, classification: "w-2")

      expect(punchcard.worked_longer_than_daily_overtime_threshold?(8)).to eq false
    end
  end
end
