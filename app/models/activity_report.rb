class ActivityReport
  include ActiveModel::Model

  attr_accessor :type, :start_date, :end_date
  validates :type, :start_date, :end_date, presence: true

  def initialize(attributes={})
    @start_date = Date.new(attributes['start_date(1i)'].to_i, attributes['start_date(2i)'].to_i, attributes['start_date(3i)'].to_i)
    @end_date = Date.new(attributes['end_date(1i)'].to_i, attributes['end_date(2i)'].to_i, attributes['end_date(3i)'].to_i)
    @type = attributes['type']
  end

  def csv_string
    # This is replacing the generate method
  end

  def csv_filename
    formatted_start_date = start_date.strftime('%-m.%-d.%Y')
    formatted_end_date = end_date.strftime('%-m.%-d.%Y')
    "#{type} #{formatted_start_date}-#{formatted_end_date}.csv"
  end

  private

  def activities
    Activity.includes(:location, :judge).between_dates(start_date, end_date)
  end
end
