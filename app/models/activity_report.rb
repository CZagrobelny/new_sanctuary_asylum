class ActivityReport < Report

  def csv_string
    # This is replacing the generate method
  end

  private

  def data
    Activity.includes(:location, :judge).between_dates(start_date, end_date)
  end
end
