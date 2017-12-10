require 'rails_helper'
require 'csv'

RSpec.describe EventReport do
  let!(:event) { FactoryGirl.create(:event) }

  let(:start_date) { Date.today.beginning_of_month }
  let(:end_date) { Date.today.end_of_month }

  let(:event_report) { EventReport.new }

  before(:each) do
    event_report.assign_attributes(start_date: start_date, 
                                      end_date: end_date)
  end

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
