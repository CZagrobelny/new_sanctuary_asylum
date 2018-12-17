require 'rails_helper'
require 'csv'

RSpec.describe ActivityReport do
  describe '.csv_string' do
    let(:judge) { FactoryGirl.create(:judge) }
    let!(:activity) { FactoryGirl.create(:activity, judge: judge) }
    let!(:accompaniment) { FactoryGirl.create(:accompaniment, activity: activity) }
    let(:start_date) { 1.month.ago }
    let(:end_date) { 1.month.from_now }
    let(:region) { activity.region }
    let(:report_params) { {"type"=>"activity", "start_date(2i)"=>start_date.strftime('%m'), "start_date(3i)"=>start_date.strftime('%d'), "start_date(1i)"=>start_date.strftime('%Y'), "end_date(2i)"=>end_date.strftime('%m'), "end_date(3i)"=>end_date.strftime('%d'), "end_date(1i)"=>end_date.strftime('%Y'), "region_id"=>region.id} }
    let(:activity_report) { ActivityReport.new(report_params) }

    subject { activity_report.csv_string }

    it 'returns a String' do
      expect(subject).to be_a(String)
    end

    it 'returns the intended data' do
      column_headers = ['Event', 'Date', 'Location Name', 'Judge', 'No. of Accompaniments']
      aggregate_failures do
        expect(CSV.parse(subject)[0]).to eq(column_headers)

        expect(subject).to include(activity.activity_type.name.humanize)
        expect(subject).to include(activity.location.name)
        expect(subject).to include(activity.judge.name)
        expect(subject).to include(activity.accompaniments.count.to_s)
      end
    end
  end
end
