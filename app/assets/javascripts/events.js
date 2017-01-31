// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

jQuery(function() {

    $('#send-emails-modal').on('show.bs.modal', function (event) {
        var button = $(event.relatedTarget);
        var header = button.data('title');
        var list = button.data('list');
        var modal = $(this);
        modal.find('.modal-title').text(header);
        modal.find('#send-emails-mailto').attr('href', 'mailto:' + list);
        modal.find('#send-emails-list').val(list);
    });

    var users = jQuery('#users');
    var groups = jQuery('#groups');

    jQuery('#all').change(function(event) {
        var method = event.target.checked ? 'select_all' : 'deselect_all';
        users.multiSelect(method);
        groups.multiSelect(method);
    });

    var unable_all_on_deselect = function() {
        jQuery('#all').attr('checked', false);
    };

    users.multiSelect({
        afterDeselect: unable_all_on_deselect
    });
    groups.multiSelect({
        afterDeselect: unable_all_on_deselect
    });
});

function addCustomApplicationField() {
  jQuery(CUSTOM_APPLICATION_FIELD_TEMPLATE)
    .insertBefore('#add-custom-application-fields');
}

function removeCustomApplicationField(button) {
  jQuery(button).parents('.input-group').remove();
}

function addEventDatePicker() {
  var picker = jQuery('#event-add-date-picker');

  jQuery(EVENT_DATE_PICKER_TEMPLATE)
    .insertBefore(picker);

  enableDatepickers();
}

function removeEventDatePicker(button) {
  jQuery(button).parent('div').remove();
}

function flipAllCheckboxes(rootCheckbox) {
  if (rootCheckbox.checked) {
    jQuery(':checkbox.'.concat(rootCheckbox.className)).each(function() {
      this.checked = true;
    });
  } else {
    jQuery(':checkbox.'.concat(rootCheckbox.className)).each(function() {
      this.checked = false;
    });
  }
}
