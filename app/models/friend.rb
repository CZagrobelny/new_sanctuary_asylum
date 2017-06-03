class Friend < ActiveRecord::Base
  validates :first_name, :last_name, presence: true
  validates :a_number, presence: { if: :a_number_available? }, numericality: { if: :a_number_available? }
  validates :a_number, length: { minimum: 8, maximum: 9 }, if: :a_number_available?

  private

  def a_number_available?
    self.no_a_number == false
  end
end