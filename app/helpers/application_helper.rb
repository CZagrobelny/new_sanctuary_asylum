module ApplicationHelper

  def display_validation_errors(resource)
    if resource.errors.present?
      content_tag :ul do
        resource.errors.full_messages.each do |message|
          concat content_tag(:li, message)
        end
      end
    end
  end

end
