$(document).on('turbolinks:load', function () {
  activateSanctuariesChosen();
});

function activateSanctuariesChosen() {
  $('.chosen-select').chosen({
    allow_single_deselect: true,
    no_results_text: 'No results matched',
    width: '100%'
  });
}
