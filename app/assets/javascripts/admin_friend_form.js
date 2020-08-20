$(document).on('turbolinks:load', function () {
  activateChosen();

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

  $('#detention_case_status').change(function() {
    if ($(this).find('option:selected').text() == "Other") {
      $('.other_case_status_wrapper').show();
    } else {
      if ($('.other_case_status_wrapper').is(":visible")) {
        $('#detention_other_case_status').val('');
        $('.other_case_status_wrapper').hide();
      }
    }
  });

  $('#friend_no_a_number').change(function() {
    if ($(this).prop('checked')) {
      $('#friend_a_number').val('');
    }
  });

  $('#add_family_relationship_modal').on('shown.bs.modal', function(){
    $('#new_family_relationship')[0].reset();
  });

  $('.open_activity_modal').click(function() {
    $('#activity_modal').modal('show');
  });

  $('.open_detention_modal').click(function() {
    $('#detention_modal').modal('show');
  });

  $('.open_ankle_monitor_modal').click(function() {
    $('#ankle_monitor_modal').modal('show');
  });

  $('.open_friend_note_modal').click(function() {
    $('#friend_note_modal').modal('show');
  });
});

function activateChosen() {
  var all_chosen_selects = $('.chzn-select');
  for (var i=0; i<all_chosen_selects.length;i++) {
    var chosen_select = all_chosen_selects[i];
    var attributes = {};
    if (chosen_select.id == 'filterrific_activity_type') {
      attributes['width'] = '33%'
    } else if (
      chosen_select.id == 'filterrific_activity_location' ||
      chosen_select.id == 'filterrific_activity_judge'
    ) {
      attributes['width'] = '45%'
    } else if (chosen_select.id == 'filterrific_country_of_origin') {
      attributes['width'] = '66%'
    } else {
      attributes['width'] = '100%'
    }
    $(chosen_select).select2(attributes);
  }
}
