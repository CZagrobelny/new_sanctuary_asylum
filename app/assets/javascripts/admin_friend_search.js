$(document).on('turbolinks:load', function () {
  $('#query').on('keyup', function(e) {
    if (e.which == 13) {
      this.closest('form').submit()
    }
  });

  $('[data-toggle-search-filters=true]').on('click', function () {
    $('.friend-search-filters').toggle();
    return false;
  });

  $('[data-search-filter=true]').on('change', function () {
    if (checkOneYearDeadlineRange()) {
      $(this).closest('form').submit();
    }
  });

  $(".datepicker").datepicker();
});

function checkOneYearDeadlineRange() {
  var floor = $('#deadlines_ending_floor').datepicker().val();
  var ceiling = $('#deadlines_ending_ceiling').datepicker().val();
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
