$(document).on('turbolinks:load', function () {
  // Used to toggle the visibility of the advanced search filters on friend and user admin search
  $('[data-toggle-search-filters=true]').on('click', function () {
    $('.search-filters').toggle();
    return false;
  });

  // Used on volunteer admin search, selecting a volunteer type
  $('#volunteer_type').on('change', function () {
    $(this).closest('form').submit()
  });

  // For friend advanced search, submit search form (since the submit on enter doesn't work with multiple text fields in a form)
  $('#friend-query').on('keyup', function(e) {
    if (e.which == 13) {
      this.closest('form').submit()
    }
  });

  // Submit the friend search form if there are changes and the deadline range is valid
  $('[data-search-filter=true]').on('change', function (e) {
    if (validateDateRange('deadlines_ending') && validateDateRange('created_at')) {
      $(this).closest('form').submit();
    }
  });

  // For friend search, initialize datepickers for the deadlines
  $(".datepicker").datepicker();
});

function validateDateRange(attribute) {
  var floor_id = '#' + attribute + '_floor'
  var ceiling_id = '#' + attribute + '_ceiling'

  var floor = $(floor_id).datepicker().val();
  var ceiling = $(ceiling_id).datepicker().val();
  if (isEmpty(floor) && isEmpty(ceiling)) {
    return true
  } else if (!isEmpty(floor) && !isEmpty(ceiling)) {
    return true
  } else {
    return false
  }
}

function isEmpty(str) {
  return (!str || 0 === str.length);
}
