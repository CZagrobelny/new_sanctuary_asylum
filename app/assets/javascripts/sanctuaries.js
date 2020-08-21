$(document).on('turbolinks:load', function () {
  activateSanctuariesSelect2();
});

function activateSanctuariesSelect2() {
  $('.js-select2-sanctuaries').select2({
    width: '100%'
  });
}
