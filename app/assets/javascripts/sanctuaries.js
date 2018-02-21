$(document).on('turbolinks:load', function () {
  activateSanctuariesChosen();
});

function activateSanctuariesChosen() {
  var all_chosen_selects = $('.chosen-select');
  for (var i=0; i<all_chosen_selects.length;i++) {
    var chosen_select = all_chosen_selects[i];
    $(chosen_select).chosen({
      allow_single_deselect: true,
      no_results_text: 'No results matched',
      width: '100%'
    });

    // remove duplicated chosen-containers
    if ($(chosen_select).next().next().hasClass('chosen-container')) {
      $(chosen_select).next().next().remove();
    }
  }
}
