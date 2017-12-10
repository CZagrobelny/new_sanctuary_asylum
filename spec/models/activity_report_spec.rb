require 'rails_helper'
require 'csv'

RSpec.describe ActivityReport do
  describe '.csv_string' do
    let(:judge) { FactoryGirl.create(:judge) }
    let!(:activity) { FactoryGirl.create(:activity, judge: judge) }
    let(:accompaniment) { FactoryGirl.create(:accompaniment, activity: activity) }

    let(:start_date) { Date.today.beginning_of_month }
    let(:end_date) { Date.today.end_of_month }

    let(:activity_report) { ActivityReport.new }

    subject { activity_report.csv_string }

    before(:each) do
      activity_report.assign_attributes(start_date: start_date, 
                                        end_date: end_date)
    end

    it 'returns a String' do
      expect(subject).to be_a(String)
    end

    it 'returns the intended data' do
      column_headers = ['Event', 'Date', 'Location Name', 'Judge', 'No. of Accompaniments']
      aggregate_failures do
        expect(CSV.parse(subject)[0]).to eq(column_headers)

        expect(subject).to include(activity.event.humanize)
        expect(subject).to include(activity.location.name)
        expect(subject).to include(activity.judge.name)
        expect(subject).to include(activity.accompaniments.count.to_s)
      end
    end
  end
end
