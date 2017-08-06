class AccompanimentReportAuthorship < ActiveRecord::Base
  belongs_to :user
  belongs_to :accompaniment_report
end