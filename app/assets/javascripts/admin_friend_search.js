$(document).on('turbolinks:load', function () {
  $('[data-toggle-search-filters=true]').on('click', function () {
    $('.friend-search-filters').toggle();
    return false;
  });

  $('[data-search-filter=true]').on('change', function () {
    $(this).closest('form').submit()
  });
});
