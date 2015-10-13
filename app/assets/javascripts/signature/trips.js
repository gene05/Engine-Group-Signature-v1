function loadFunctionsTrips() {
  if($('#body-group-signature .signature-trips#trips-container .set-delete-trip').length){
    $.rails.allowAction = function(link){
      if (link.data("confirm") === undefined){
        return true;
      }
      dialogDelete('', link, 'trip');
      return false;
    };

    $.rails.confirmed = function(link){
      link.data("confirm", null);
      link.trigger("click.rails");
    };
  }

  if($('#body-group-signature .new-trip-container#trip-container').length){
    clickButtonsForm();
  }

  if($('#body-group-signature .signature-trips#trips-container').length){
    clickButtons();
  }

  $("#body-group-signature form").on("keypress", function (e) {
      if (e.keyCode === 13) {
          return false;
      }
  });

  $("body#body-group-signature").on("click", "a.signature-icon", function(){
    selectIcon(this);
  });

  if($('#body-group-signature .new-trip-container input[type=checkbox]').length){
    selectPassengers();
  }

  if(getUrlVariable('import')){
    setPopup();
  }

  $("#body-group-signature #new-trip-popup input[name='trip[name]']").change(function() {
    var trip_name = $("#body-group-signature #new-trip-popup input[name='trip[name]']").val();
    $("#body-group-signature #new-trip-popup #import-form-passengers input#import_trip").val(trip_name);
  });

  $("#body-group-signature #edit-trip-popup input[name='trip[name]']").change(function() {
    var trip_name = $("#body-group-signature #edit-trip-popup input[name='trip[name]']").val();
    $("#body-group-signature #edit-trip-popup #import-form-passengers input#import_trip").val(trip_name);
  });
}

function clickButtonsForm(){
  $("#body-group-signature .new-trip-container#trip-container .btn-passenger-document").click(function() {
    addPassengerTripbyDocument(data(this, 'action'));
  });

  $("#body-group-signature .new-trip-container#trip-container .btn-passenger").click(function() {
    addPassengerTrip(data(this, 'action'));
  });

  $("#body-group-signature .new-trip-container#trip-container .close-passenger-document").click(function() {
    cancelAddDocumentPassenger(data(this, 'action'));
  });

  $("#body-group-signature .new-trip-container#trip-container .passenger-b-close").click(function() {
    cancelAddPassenger(data(this, 'action'));
  });

  $("#body-group-signature .new-trip-container#trip-container .btn-add-a-passenger").click(function() {
    addAPassengerInTrip(data(this, 'action'));
  });

  $("#body-group-signature .new-trip-container#trip-container #btn-add-trip").click(function() {
    if(data(this, 'action')==="new"){
      addTrip();
    }else{
      editTrip();
    }
  });
}

function clickButtons(){
  $("#body-group-signature .signature-trips#trips-container #btn-list-add-trip").click(function() {
    addATrip('new');
  });

  $("#body-group-signature .signature-trips#trips-container #btn-list-edit-trip").click(function() {
    editThisTrip(data(this, 'id'), 'edit');
  });
}

function data(obj, type){
  return $(obj).data(type);
}

function selectIcon(obj){
  var title = $(obj).attr("title");
  if(title==="Delete Passenger"){
    dialogDelete(obj, '', 'passenger');
  }
}

function dialogDelete(obj, link, subject){
  Ply.dialog({
      "other-step": {
          ui: "confirm",
          data: {
              text: "Are you sure you want to delete the "+subject+"?",
              ok: "Confirm",     // button text
              cancel: "Cancel"
          },
          backEffect: "3d-flip[-180,180]"
      }
  }).always(function (ui) {
    if (ui.state) {
      if(subject==='trip'){
        $.rails.confirmed(link);
      }else if(subject==='passenger'){
        removingPassenger(obj);
      }
    }
  });
}

function removingPassenger(obj){
  var passenger_id = $(obj).data('id');
  var trip_id = $('div#trip-id', $(obj).parents().eq(4)).text();
  var selector = trip_id !=="" ? '#edit-trip-popup' : '#new-trip-popup';
  var list_passengers = $('#body-group-signature '+selector+' .row-signature-list-passengers');
  var data_trip = {'trip_id': trip_id };
  $.ajax({
    method: "DELETE",
    url: "/signature/passengers/"+passenger_id,
    data: data_trip,
    success: function(result) {
      $(obj).parent().remove();
      appendMessage('green', selector, result.notice);
      if(!$.trim(list_passengers.html())){
        list_passengers.append('<div class="table-column table-column-1 signature-not-content"><p>You have not assigned passengers</p></div>');
      }
      $('#body-group-signature '+selector+' #import-form-passengers input.passenger-'+passenger_id).remove();
    }
  });
}

function setPagePopup(action){
  if(getUrlVariable('page')){
    $('#body-group-signature #'+action+'-trip-popup #import-form-passengers input#page').val(getUrlVariable('page'));
  }
}

function setPopup(){
  var status = getUrlVariable('import');
  var color = status==='true' ? 'green' : 'red';
  var selector = getUrlVariable('id') ? '#edit-trip-popup' : '#new-trip-popup';
  var rows = $('#body-group-signature '+selector+' .signature-error-row').text();
  var message = status==='true' ? 'Passengers successfully added' : caseErrorMessage(rows);
  showPopup();
  appendMessage(color, selector, message);
}

function caseErrorMessage(rows) {
  var error = getUrlVariable('error');
  if(error==='format'){
    return 'Import document is invalid, the format must be .csv';
  }else if(error==='empty'){
    return 'The imported document is empty';
  }else{
    return 'Check the line #'+rows+' of the document, it has an empty field or wrong';
  }
}

function showPopup() {
  if(getUrlVariable('id')){
    editThisTrip(getUrlVariable('id'), 'import');
  }else{
    addATrip('import');
  }
}

function appendMessage(color, selector, message){
  $('#body-group-signature '+selector+' .signature-message').addClass('message-color-'+color);
  $('#body-group-signature '+selector+' .signature-message').fadeIn();
  $('#body-group-signature '+selector+' .signature-message').show();
  $('#body-group-signature '+selector+' .signature-message').html(message);
  $('#body-group-signature '+selector+' .signature-message').delay(3200).queue(function(){
      $('#body-group-signature '+selector+' .signature-message').fadeOut(400).html('').removeClass('message-color-'+color);
  });
}

function addATrip(action){
  setPagePopup(action);
  var speed = action === 'import' ? 0 : 350;
  var transition = action === 'import' ? false : 'slideBack';
  if(action === 'new'){
    $('#body-group-signature #new-trip-popup input[type=checkbox]').prop('checked', false);
  }
  var previous_passengers = $('#body-group-signature #new-trip-popup #previous_passengers_ids_');
  var row_no_passengers = $('#body-group-signature #new-trip-popup .row-signature-list-passengers .signature-not-content');
  if(!previous_passengers.length && !row_no_passengers.length){
    notSignedPassengers('new');
  }
  $('#body-group-signature #new-trip-popup').css("width", ($(window).width()-100)+"px");
  $('#body-group-signature #new-trip-popup').css("height", ($(window).height()-$('#body-group-signature .signature-header').height())+"px");
  $('#body-group-signature #new-trip-popup').bPopup({
    speed: speed,
    followSpeed: 1500 ,
    position: [100, 'auto'],
    positionStyle: 'fixed',
    follow: [true, false],
    modalColor: 'black',
    transition: transition,
    transitionClose: 'slideBack'
  });
}

function selectPassengers(){
  $('#body-group-signature .new-trip-container input[type=checkbox]').click(function(){
    if($(this).val() === 'all'){
      if($(this).is(":checked")){
        selectOrDeselectAllCheck('.new-trip-container', true);
      } else if($(this).is(":not(:checked)")){
        selectOrDeselectAllCheck('.new-trip-container', false);
        document.getElementById('btn-add-trip').disabled=true;
      }
    }
   });
}

function addPassengerTrip(action){
  cancelAddDocumentPassenger(action);
  $('#body-group-signature #'+action+'-trip-popup .signature-section-form-passengers').removeClass('hidden');
}

function cancelAddPassenger(action){
  $('#body-group-signature #'+action+'-trip-popup .signature-section-form-passengers').addClass('hidden');
  $('#body-group-signature #'+action+'-trip-popup .signature-section-form-passengers input').val('');

}

function addTrip(){
  cancelAddPassenger('new');
  var selector = '#new-trip-popup';
  if(notCheckSelect(selector) || fieldEmpty(selector, 'trip[name]')){
    validatingTrip(selector);
  }else{
    var trip_name = $("#body-group-signature #new-trip-popup .form-new-trip .input-new-title").val();
    var passengers = [];
    $.each($("#body-group-signature #new-trip-popup .new-trip-container input[name='passengers_ids[]']:checked"), function(){            
      passengers.push($(this).val());
    });
    var trip_data = {'trip[name]': trip_name, 'passengers_ids': passengers };
    $.post("/signature/trips", trip_data, function( data ) {
      if(data.status === true){
        $('#body-group-signature #new-trip-popup .b-close').click();
        window.location.href="/signature/trips?success=added";
      }
    });
  }
}

function editThisTrip(id, action){
  setPagePopup(action);
  var speed = action === 'import' ? 0 : 350;
  var transition = action === 'import' ? false : 'slideBack';
  $('#body-group-signature #edit-trip-popup #import-form-passengers #id').val(id);
  $('#body-group-signature #edit-trip-popup #import-form-passengers #previous_passengers_ids_').remove();
  $('#body-group-signature #edit-trip-popup').css("width", ($(window).width()-100)+"px");
  $('#body-group-signature #edit-trip-popup').css("height", ($(window).height()-$('#body-group-signature .signature-header').height())+"px");
  $('#body-group-signature #edit-trip-popup').bPopup({
    speed: speed,
    followSpeed: 1500 ,
    position: [100, 'auto'],
    positionStyle: 'fixed',
    follow: [true, false],
    modalColor: 'black',
    transition: transition,
    transitionClose: 'slideBack',
    onOpen: function(){
      $.get("/signature/trips/"+id+"/edit", function( data ) {
        if(data.status === true){
          $('#body-group-signature #edit-trip-popup input[type=checkbox]').prop('checked', false);
          cancelAddPassenger(action);
          $('#body-group-signature #edit-trip-popup .row-signature-list-passengers .table-column').remove();
          $("#body-group-signature #edit-trip-popup .edit-trip-container input#trip_name").val(data.trip.name);
          $("#body-group-signature #edit-trip-popup .edit-trip-container #trip-id").text(data.trip.id);
          if(data.passengers.length>0){
            $.each(data.passengers, function(index, value){
              var passenger = '<div class="table-column table-column-1"><input type="checkbox" checked name="passengers_ids[]" id="passengers_ids_" class="signature-check-hidden" value="'+value.id+'"><span class="signature-passenger-name-email">'+value.name+' ('+value.email+')</span> <a class="signature-icon signature-icon-right" data-id="'+value.id+'" href="#" title="Delete Passenger"><i class="fa fa-times"></i></span></a></div>';
              $('#body-group-signature #edit-trip-popup .table-body .row-signature-list-passengers').prepend(passenger);
              $('#body-group-signature #edit-trip-popup #import-form-passengers').append('<input type="hidden" name="previous_passengers_ids[]" id="previous_passengers_ids_" class="passenger-'+value.id+'" value="'+value.id+'">');
              assignedPassengers(action);
            });
          }else{
            notSignedPassengers(action);
          }
        }
      });
    }
  });
}

function editTrip(){
  var selector = '#edit-trip-popup';
  if(notCheckSelect(selector) || fieldEmpty(selector, 'trip[name]')){
    validatingTrip(selector);
  }else{
    var id = $("#body-group-signature #edit-trip-popup .edit-trip-container #trip-id").text();
    var trip_name = $("#body-group-signature #edit-trip-popup .edit-trip-container #trip_name").val();
    var passengers = [];
    $.each($("#body-group-signature #edit-trip-popup .edit-trip-container input[type=checkbox]:checked"), function(){            
      passengers.push($(this).val());
    });
    trip_data = {'trip[name]': trip_name, 'passengers_ids': passengers};

    $.ajax({
      method: "PUT",
      url: "/signature/trips/"+id,
      data: trip_data,
      success: function() {
        $('#body-group-signature #edit-trip-popup .b-close').click();
        window.location.href="/signature/trips?success=updated";
      }
    });
  }
}

function addAPassengerInTrip(action){
  var selector = '#'+action+'-trip-popup .signature-section-form-passengers';
  if(fieldEmpty(selector, 'name') || fieldEmpty(selector, 'email') || notEmailFormat(selector+' #email')){
    validatingPassenger(selector);
  }else{
    var passenger_name = $("#body-group-signature #"+action+"-trip-popup .signature-section-form-passengers #name").val();
    var passenger_email = $('#body-group-signature #'+action+'-trip-popup .signature-section-form-passengers #email').val();
    var trip_id = $("#body-group-signature #"+action+"-trip-popup form .field-new-trip div#trip-id").text();

    var passenger_data = {'name': passenger_name, 'email': passenger_email, 'trip_id': trip_id };
    $.post("/signature/passengers/", passenger_data, function( data ) {
      if(data.status === true){
        cancelAddPassenger(action);
        var new_passenger = '<div class="table-column table-column-1"><input type="checkbox" checked name="passengers_ids[]" id="passengers_ids_" class="signature-check-hidden" value="'+data.passenger.id+'"><span class="signature-passenger-name-email">'+data.passenger.name+' ('+data.passenger.email+')</span><a class="signature-icon signature-icon-right" data-id="'+data.passenger.id+'" href="#" title="Delete Passenger"><i class="fa fa-times"></i></a></div>';
        $('#body-group-signature #'+action+'-trip-popup .table-body .row-signature-list-passengers').prepend(new_passenger);
        assignedPassengers(action);
        $('#body-group-signature #'+action+'-trip-popup #import-form-passengers').append('<input type="hidden" name="previous_passengers_ids[]" id="previous_passengers_ids_" class="passenger-'+data.passenger.id+'" value="'+data.passenger.id+'">');
        appendMessage('green', '#'+action+'-trip-popup', data.notice);
      }
    });
  }
}

function assignedPassengers(action){
  $('#body-group-signature #'+action+'-trip-popup .table-body .row-signature-list-passengers .signature-not-content').remove();
}

function notSignedPassengers(action){
  $('#body-group-signature #'+action+'-trip-popup .table-body .row-signature-list-passengers').append('<div class="table-column table-column-1 signature-not-content"><p>You have not assigned passengers</p></div>');
}

function addPassengerTripbyDocument(action){
  cancelAddPassenger(action);
  $('#body-group-signature #'+action+'-trip-popup .section-form-import-passengers').removeClass('hidden');
  $('#body-group-signature #'+action+'-trip-popup .actions').addClass('btn-more-down');
}

function cancelAddDocumentPassenger(action){
  $('#body-group-signature #'+action+'-trip-popup .section-form-import-passengers').addClass('hidden');
  $('#body-group-signature #'+action+'-trip-popup .actions').removeClass('btn-more-down');
  var control = $("#body-group-signature #"+action+"-trip-popup .section-form-import-passengers #file");
  control.replaceWith( control = control.clone( true ) );
}







