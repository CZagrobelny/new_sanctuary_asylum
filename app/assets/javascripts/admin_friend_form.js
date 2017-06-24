$(document).ready(function () {
  $('.chzn-select').chosen({
    allow_single_deselect: false,
    no_results_text: 'No results matched'
  });

  $('#friend_ethnicity').change(function() {
    if ($(this).find('option:selected').text() == "Other") {
      $('.other_ethnicity_wrapper').show();
    } else {
      if ($('.other_ethnicity_wrapper').is(":visible")) {
        $('#friend_other_ethnicity').val('');
        $('.other_ethnicity_wrapper').hide();
      }
    }
  });

  $('#friend_no_a_number').change(function() {
    if ($(this).prop('checked')) {
      $('#friend_a_number').val('');
    }
  });
});
