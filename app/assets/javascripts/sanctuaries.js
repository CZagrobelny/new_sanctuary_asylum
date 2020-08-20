$(document).on('turbolinks:load', function () {
  activateSanctuariesChosen();
});

function activateSanctuariesChosen() {
  $('.chzn-select-sanctuaries').select2({
    width: '100%'
  });
}
