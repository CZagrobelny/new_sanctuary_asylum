module SimpleCalendarDateChooser
  def calculate_month_advances(choice)
    current_month = Time.now.month
    choice_month = choice.to_time.month

    choice_month - current_month
  end

  def change_month(choice)
    advances = calculate_month_advances(choice)

    advances.times do
      within('.calendar-heading') { click_link 'Next' }
    end
  end
end
