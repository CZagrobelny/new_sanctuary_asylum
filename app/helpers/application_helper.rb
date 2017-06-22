module ApplicationHelper

  def display_validation_errors(resource)
    if resource.errors.present?
      content_tag :ul, class: 'error-list' do
        resource.errors.full_messages.each do |message|
          concat content_tag(:li, message)
        end
      end
    end
  end

  BOOTSTRAP_FLASH_MSG = {
    success: 'alert-success',
    error: 'alert-danger',
    alert: 'alert-warning',
    notice: 'alert-info'
  }

  def bootstrap_class_for(flash_type)
    BOOTSTRAP_FLASH_MSG.fetch(flash_type.to_sym, flash_type.to_s)
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)}", role: "alert") do
        concat content_tag(:button, 'x', class: "close", data: { dismiss: 'alert' })
        concat message 
      end)
    end
    nil
  end

end
