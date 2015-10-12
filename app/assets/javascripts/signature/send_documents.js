function loadFunctionsSendDocuments(){
  if($('.send-documents-container input[type=checkbox]').length){
    selectDocument();
  }
};

function validateCheckedDocuments(){
  if($('.send-documents-container input[type=checkbox]').is(":checked")){
    document.getElementById('btn-sending-document').disabled=false;
  }else{
    document.getElementById('btn-sending-document').disabled=true;
  }
}

function selectDocument(){
  $('.send-documents-container input[type=checkbox]').click(function(){
    validateCheckedDocuments();
    if($(this).val() == 'all'){
      if($(this).is(":checked")){
        selectOrDeselectAllCheck('.send-documents-container', true)
      } else if($(this).is(":not(:checked)")){
        selectOrDeselectAllCheck('.send-documents-container', false)
        document.getElementById('btn-sending-document').disabled=true;
      }
    }
   });
}

function sendDocumentsToTrip(){
  selectOrDeselectAllCheck('.send-documents-container', false)
  selectDocument();
  $('#body-group-signature #send-documents-popup').css("width", ($(window).width()-100)+"px");
  $('#body-group-signature #send-documents-popup').css("height", ($(window).height()-$('#body-group-signature .signature-header').height())+"px");
  $('#send-documents-popup').bPopup({
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



