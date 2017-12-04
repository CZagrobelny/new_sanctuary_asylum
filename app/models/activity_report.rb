class ActivityReport
  include ActiveModel::Model

  attr_accessor :start_date, :end_date, :start_day, :start_month, :start_year, :end_day, :end_month, :end_year, :activities
  validates :start_day, :start_month, :start_year, :end_day, :end_month, :end_year, presence: true
  DATE_ATTRIBUTE_MAPPING = [['start_day', 'start_date(3i)'], ['start_month', 'start_date(2i)'], ['start_year', 'start_date(1i)'], ['end_day', 'end_date(3i)'], ['end_month', 'end_date(2i)'], ['end_year', 'end_date(1i)']] 

  def initialize(attributes={})
    new_hash = Hash.new
    DATE_ATTRIBUTE_MAPPING.each do |mapping|
      new_key = mapping[0]
      initial_key = mapping[1]
      new_hash[new_key] = attributes[initial_key] ? attributes[initial_key].to_i : nil
    end

    super new_hash
  end

  def csv_string
    # This is replacing the generate method
  end

  def csv_filename
    formatted_start_date = start_date.strftime('%-m.%-d.%Y')
    formatted_end_date = end_date.strftime('%-m.%-d.%Y')
    "#{type} #{formatted_start_date}-#{formatted_end_date}.csv"
  end

  def has_data?
    activities.present?
  end

  private

  def start_date
    @start_date ||= Date.new(start_year, start_month, start_day)
  end

  def end_date
    @end_date ||= Date.new(end_year, end_month, end_day)
  end

  def activities
    @activities ||= Activity.includes(:location, :judge).between_dates(start_date, end_date)
  end
end
