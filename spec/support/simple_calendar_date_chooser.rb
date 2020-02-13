module SimpleCalendarDateChooser
  def calculate_month_advances(choice)
    current_month = Time.now.month
    choice_month = choice.to_time.month

    advances = choice_month - current_month
    if advances < 0
      advances += 12
    end
    advances
  end

  def change_month(choice)
    advances = calculate_month_advances(choice)

    advances.times do
      within('.calendar-heading') { click_link 'Next' }
    end
    # This expect will force capybara to wait for ajax up to 2 seconds.
    # If tests using this helper are still failing we can consider customizing
    # the wait time.
    expect(page).to have_content(choice.strftime("%B"))
  end
end
