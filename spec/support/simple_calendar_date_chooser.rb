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
    sleep 1
    # This sleep is necessary because of the simple calendar load time when we have to change_month to advance to the next month.
    # For some reason, the default Capybara wait time functionality or setting a wait time for 'find' was NOT helping
    # us pick up these links loaded iin simple calendar, even when the wait far exceeds the 1 second sleep. It is puzzling :/
    # So I figured, adding an extra 10 seconds to our test run toward the end of the month (when we need to advance to the next month)
    # is the best solution for now...
  end
end
