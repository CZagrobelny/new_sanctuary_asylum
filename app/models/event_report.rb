class EventReport < Report
  def csv_string
    column_headers = ['Category', 'Title', 'Date', 'Location Name', 'No. of Friends Attending', 'No. of Volunteers Attending']

    CSV.generate(headers: true) do |csv|
      csv << column_headers

      data.each do |event|
        row = []
        row << event.category.humanize
        row << event.title
        row << event.date.strftime('%m/%d/%Y')
        row << event.location.try(:name)
        row << event.friends.count
        row << event.users.count
        csv << row
      end
    end
  end

  private

  def data
    Event.includes(:location)
         .where(community_id: community_id)
         .between_dates(start_datetime, end_datetime)
         .order(:date)
  end
end
