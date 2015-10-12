 function loadFunctionsDocumentsSigned(){
  if($('#body-group-signature #show-document-signed .show-signature').length){
    var sigature_draw = $('#body-group-signature #show-document-signed .show-signature .sigPad input.output').val();
    sign = $('#body-group-signature #show-document-signed .show-signature .sigPad').signaturePad({
        lineWidth: 0,
        penColour: '#000',
        penWidth: 1,
        validateFields: false,
        displayOnly: true
    });

    if(sigature_draw){
      var json = JSON.stringify(eval("(" + sigature_draw + ")"));
      sign.regenerate(json);
    }
  }
};