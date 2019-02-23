require 'rails_helper'
require 'csv'

RSpec.describe EventReport do
  let!(:event) { FactoryBot.create(:event) }
  let(:start_date) { 1.month.ago }
  let(:end_date) { 1.month.from_now }
  let(:community) { event.community }
  let(:report_params) { {"type"=>"event", "start_date(2i)"=>start_date.strftime('%m'), "start_date(3i)"=>start_date.strftime('%d'), "start_date(1i)"=>start_date.strftime('%Y'), "end_date(2i)"=>end_date.strftime('%m'), "end_date(3i)"=>end_date.strftime('%d'), "end_date(1i)"=>end_date.strftime('%Y'), "community_id"=>community.id} }
  let(:event_report) { EventReport.new(report_params) }

  describe '.csv_string' do
    it 'returns a String' do
      expect(event_report.csv_string).to be_a(String)
    end

    it 'returns the intended data' do
      column_headers = ['Category', 'Title', 'Date', 'Location Name', 'No. of Friends Attending', 'No. of Volunteers Attending']
      aggregate_failures do
        expect(CSV.parse(event_report.csv_string)[0]).to eq(column_headers)

        expect(event_report.csv_string).to include(event.category.humanize)
        expect(event_report.csv_string).to include(event.title)
        expect(event_report.csv_string).to include(event.date.strftime('%m/%d/%Y'))
        expect(event_report.csv_string).to include(event.location.name)
      end
    end
  end
end
