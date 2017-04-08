module WaitForAjax
  # @see http://robots.thoughtbot.com/automatically-wait-for-ajax-with-capybara Automatically wait for AJAX with Capybara
  def finished_all_ajax_requests?
    return_value = page.evaluate_script <<-SCRIPT.strip.gsub(/\s+/, ' ')
      (function () {
        if (typeof jQuery != 'undefined') {
          return jQuery.active;
        }
        else {
          console.log("Failed on the page: " + document.URL);
          console.error("An error occurred when checking for `jQuery.active`.");
        }
      })()
    SCRIPT
    return_value&.zero?
  end

  # @see http://robots.thoughtbot.com/automatically-wait-for-ajax-with-capybara Automatically wait for AJAX with Capybara
  def wait_for_ajax(wait_time: nil)
    wait_time ||= Capybara.default_max_wait_time

    Timeout.timeout(wait_time) do
      loop until finished_all_ajax_requests?
    end
  end
end