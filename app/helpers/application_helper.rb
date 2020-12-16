module ApplicationHelper
  BOOTSTRAP_FLASH_MSG = {
    success: 'alert-success',
    error: 'alert-danger',
    alert: 'alert-warning',
    notice: 'alert-info'
  }.freeze

  def bootstrap_class_for(flash_type)
    BOOTSTRAP_FLASH_MSG.fetch(flash_type.to_sym, flash_type.to_s)
  end

  def display_validation_errors(resource)
    return unless resource.errors.present?

    content_tag :ul, class: 'error-list' do
      resource.errors.full_messages.each do |message|
        concat content_tag(:li, message)
      end
    end
  end

  def available_roles
    roles = current_community.primary? ? User::PRIMARY_ROLES : User::NON_PRIMARY_ROLES
    if current_user.regional_admin?
      roles + [['Remote Clinic Lawyer', 'remote_clinic_lawyer']]
    else
      roles
    end
  end

  def locations_by_name(region)
    region.locations.order('name')
  end

  def us_states_options
    [
      ['Select a State', nil],
      %w[Alabama AL],
      %w[Alaska AK],
      %w[Arizona AZ],
      %w[Arkansas AR],
      %w[California CA],
      %w[Colorado CO],
      %w[Connecticut CT],
      %w[Delaware DE],
      ['District of Columbia', 'DC'],
      %w[Florida FL],
      %w[Georgia GA],
      %w[Hawaii HI],
      %w[Idaho ID],
      %w[Illinois IL],
      %w[Indiana IN],
      %w[Iowa IA],
      %w[Kansas KS],
      %w[Kentucky KY],
      %w[Louisiana LA],
      %w[Maine ME],
      %w[Maryland MD],
      %w[Massachusetts MA],
      %w[Michigan MI],
      %w[Minnesota MN],
      %w[Mississippi MS],
      %w[Missouri MO],
      %w[Montana MT],
      %w[Nebraska NE],
      %w[Nevada NV],
      ['New Hampshire', 'NH'],
      ['New Jersey', 'NJ'],
      ['New Mexico', 'NM'],
      ['New York', 'NY'],
      ['North Carolina', 'NC'],
      ['North Dakota', 'ND'],
      %w[Ohio OH],
      %w[Oklahoma OK],
      %w[Oregon OR],
      %w[Pennsylvania PA],
      ['Rhode Island', 'RI'],
      ['South Carolina', 'SC'],
      ['South Dakota', 'SD'],
      %w[Tennessee TN],
      %w[Texas TX],
      %w[Utah UT],
      %w[Vermont VT],
      %w[Virginia VA],
      %w[Washington WA],
      ['West Virginia', 'WV'],
      %w[Wisconsin WI],
      %w[Wyoming WY]
    ]
  end

  def accompaniment_activity_classes(activity)
    [].tap do |classes|
      classes << activity.activity_type.name
      classes << 'friend_in_detention' if activity.friend.status == 'in_detention'
    end
  end

  # Maps activity type name [or other key] to hexadecimal color code
  def color_map
    {
      'high_risk_ice_check_in' => '#800080',
      'friend_in_detention' => '#e83737',
    }
  end

  def color_code
    content_tag :p, safe_join(
      color_map.map do |class_name, color|
        content_tag(:span, class_name.titlecase, class: "#{ class_name } color_code")
      end
    )
  end
end
