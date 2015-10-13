$(document).ready(loadFunctions);
$(document).on('page:load', loadFunctions);

function loadFunctions() {
  if($('#body-group-signature .signature-container .display-message').length){
    $("#body-group-signature .signature-container .display-message").delay(3200).fadeOut(300);
  }

  $('#body-group-signature .b-close').click(function(){
    closePopup($(this).data('action'));
  });

  loadFunctionsTrips();
  loadFunctionsDocuments();
  loadFunctionsClients();
  loadFunctionsSendDocuments();
  loadFunctionsPassengers();
  loadFunctionsDocumentsSigned();
};

function closePopup(action) {
  if($('#body-group-signature #new-trip-popup').length || $('#body-group-signature #edit-trip-popup').length){
    cancelAddDocumentPassenger(action);
    cancelAddPassenger(action);
    if(action=='new'){
      resetInputsTrip();
    }else if(action=='edit'){
      selectOrDeselectAllCheck('.new-trip-container', false);
    }
    window.location.replace('/signature/trips?page='+getUrlVariable('page'));
  }
}

function resetInputsTrip(){
  $('#body-group-signature .form-new-trip .input-new-title').val('');
  $('#body-group-signature #new-trip-popup input[type=checkbox]').prop('checked', false);
  cancelAddPassenger('new');
}

function getUrlVariable(variable) {
  var query = window.location.search.substring(1);
  var vars = query.split("&");
  for (var i=0;i<vars.length;i++) {
    var pair = vars[i].split("=");
    if(pair[0] == variable){return pair[1];}
  }
  return(false);
}

$(document).on('mouseleave', '#body-group-signature .option-documents', function(){
$('#body-group-signature .option-documents ul').hide();
});

$(document).on('mouseenter', '#body-group-signature .option-documents', function(){
$('#body-group-signature .option-documents ul').fadeIn();
});

$(document).on('click', '#body-group-signature .option-documents', function(){
$('#body-group-signature .option-documents ul').fadeIn();
});

function inConstruction(){
  alert('Functionality under construction');
}

function redirect(path){
  location.href='/'+path;
}

function successfully(message){
  alert(message);
  if($('#body-group-signature .b-close')){
    $('#body-group-signature .b-close').click();
  }
}

function selectOrDeselectAllCheck(selector_path, status){
  $('#body-group-signature '+ selector_path + ' input[type=checkbox]').prop('checked', status);
}

function fieldEmpty(selector_path, field_name){
  var field_value="#body-group-signature "+selector_path+" input[name='"+field_name+"']";
  return document.querySelector(field_value).validity.valueMissing
}

function notCheckSelect(selector_path){
  if(!$('#body-group-signature '+selector_path+' input[type=checkbox]').is(":checked")){
    return true;
  }
}

function notEmailFormat(selector_path){
  return document.querySelector('#body-group-signature '+selector_path).validity.typeMismatch
}

function validatingTrip(selector){
  class_name = selector.indexOf("#new-trip-popup") > -1 ? '#new-trip-popup' : '#edit-trip-popup'
  if(fieldEmpty(selector, 'trip[name]')){
    message = 'The name field must not be empty';
  }else if(notCheckSelect(selector)){
    message = 'You must assign at least one passenger to the trip';
  }
  appendMessage('red', class_name, message);
}

function validatingPassenger(selector){
  class_name = selector.indexOf("#new-trip-popup") > -1 ? '#new-trip-popup' : '#edit-trip-popup'
  if(fieldEmpty(selector, 'name')){
    message = 'The name field must not be empty';
  }else if(fieldEmpty(selector, 'email')){
    message = 'The email field must not be empty';
  }else if(notEmailFormat(selector+' #email')){
    message = 'Must enter an email, the format is example@example.com';
  }
  appendMessage('red', class_name, message);
}



