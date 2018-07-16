$(document).on('turbolinks:load', function () {
  // Used to toggle the visibility of the advanced search filters on friend and user admin search
  $('[data-toggle-search-filters=true]').on('click', function () {
    $('.search-filters').toggle();
    return false;
  });

  // Used on 'Detained' check box on the friend admin search
  $('[data-search-filter=true]').on('click', function () {
    $(this).closest('form').submit()
  });

  // Used on volunteer admin search, selecting a volunteer type
  $('#volunteer_type').on('change', function () {
    $(this).closest('form').submit()
  });
});
