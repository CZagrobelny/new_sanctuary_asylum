class Report
  include ActiveModel::Model

  attr_accessor :start_date, :end_date, :start_day, :start_month, :start_year, :end_day, :end_month, :end_year, :type, :community_id, :region_id
  validates :start_date, :end_date, :type, presence: true
  DATE_ATTRIBUTE_MAPPING = [['start_day', 'start_date(3i)'], ['start_month', 'start_date(2i)'], ['start_year', 'start_date(1i)'], ['end_day', 'end_date(3i)'], ['end_month', 'end_date(2i)'], ['end_year', 'end_date(1i)']]

  def initialize(attributes={})
    date_attribute_hash = Hash.new
    DATE_ATTRIBUTE_MAPPING.each do |mapping|
      new_key = mapping[0]
      initial_key = mapping[1]
      date_attribute_hash[new_key] = attributes[initial_key].present? ? attributes[initial_key].to_i : nil
    end

    super date_attribute_hash.merge({ type: attributes['type'], community_id: attributes['community_id'], region_id: attributes['region_id'] })
  end

  def csv_string
    nil
  end

  def csv_filename
    formatted_start_date = start_date.strftime('%-m.%-d.%Y')
    formatted_end_date = end_date.strftime('%-m.%-d.%Y')
    "#{type} #{formatted_start_date}-#{formatted_end_date}.csv"
  end

  def has_data?
    data.present?
  end

  def start_date
    @start_date ||= start_date_invalid? ? nil : Date.new(start_year, start_month, start_day)
  end

  def end_date
    @end_date ||= end_date_invalid? ? nil : Date.new(end_year, end_month, end_day)
  end

  private

  def data
    nil
  end

  def end_date_invalid?
    end_year.nil? || end_month.nil? || end_day.nil?
  end

  def start_date_invalid?
    start_year.nil? || start_month.nil? || start_day.nil?
  end
end
