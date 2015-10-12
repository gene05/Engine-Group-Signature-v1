function loadFunctionsPassengers(){
  if($('#body-group-signature .new-passenger-container input[type=checkbox]').length){
    selectTrips();
    
    $("#body-group-signature .new-passenger-container input" ).change(function() {
      validateFormPassenger();
    });
  }
};

function selectTrips(){
  $('#body-group-signature .new-passenger-container input[type=checkbox]').click(function(){
    validateFormPassenger();
    if($(this).val() == 'all'){
      if($(this).is(":checked")){
        selectAllTrip();
      } else if($(this).is(":not(:checked)")){
        deselectAllTrip();
        document.getElementById('btn-add-passenger').disabled=true;
      }
    }
   });
}

function validateFormPassenger(){
  if(validateChecks() && validateName() && validateEmail()){
    document.getElementById('btn-add-passenger').disabled=false;
  }else{
    document.getElementById('btn-add-passenger').disabled=true;
  }
}

function validateName(){
  if($('#body-group-signature .new-passenger-container #passenger_name').val().length>0){
    return true;
  }
}

function validateEmail(){
  if($('#body-group-signature .new-passenger-container #passenger_email').val().length>0){
    return true;
  }
}

function validateChecks(){
  if($('#body-group-signature .new-passenger-container input[type=checkbox]').is(":checked")){
    return true;
  }

}

function selectAllTrip(){
  $('#body-group-signature .new-passenger-container input[type=checkbox]').prop('checked', true);
}

function deselectAllTrip(){
  $('#body-group-signature .new-passenger-container input[type=checkbox]').prop('checked', false);
}


function addAPassenger(){
  $('#body-group-signature #new-passenger-popup').css("width", ($(window).width()-100)+"px");
  $('#body-group-signature #new-passenger-popup').css("height", ($(window).height()-$('#body-group-signature .signature-header').height()-0.00005)+"px");
  $('#body-group-signature #new-passenger-popup').bPopup({
    speed: 350,
    followSpeed: 1500 ,
    position: [100, 'auto'],
    positionStyle: 'fixed',
    follow: [true, false],
    modalColor: 'black',
    transition: 'slideBack',
    transitionClose: 'slideBack'
  });
}

function addPassenger(){
  passenger_data = {'passenger[name]': $(".form-new-passenger .input-new-title").val()}

  $.post("/signature/passengers", passenger_data, function( data ) {
    if(data.status == true){
      alert('Passenger successfully added');
      $('#body-group-signature #new-passenger-popup .b-close').click();
      window.location.reload(1);
    }
  });
}

function editThisPassenger(id){
  $('#body-group-signature #edit-passenger-popup').css("width", ($(window).width()-100)+"px");
  $('#body-group-signature #edit-passenger-popup').css("height", ($(window).height()-$('#body-group-signature .signature-header').height())+"px");
  $('#body-group-signature #edit-passenger-popup').bPopup({
    speed: 350,
    followSpeed: 1500 ,
    position: [100, 'auto'],
    positionStyle: 'fixed',
    follow: [true, false],
    modalColor: 'black',
    transition: 'slideBack',
    transitionClose: 'slideBack',
    onOpen: function(){
      $.get("/signature/passengers/"+id+"/edit", function( data ) {
        if(data.status == true){
          $(".edit-passenger-container input#passenger_name").val(data.passenger.name);
          $(".edit-passenger-container #passenger-id").text(data.passenger.id);
        }
      });
    }

  });
}

function editPassenger(){
  var id = $(".edit-passenger-container #passenger-id").text();
  passenger_data = {'passenger[name]': $(".edit-passenger-container #passenger_name").val()}

  $.ajax({
    method: "PUT",
    url: "/signature/passengers/"+id,
    data: passenger_data,
    success: function(result) {
      alert('Passenger successfully updated');
      $('#body-group-signature #edit-passenger-popup .b-close').click();
      window.location.reload(1);
    }
  });
}
