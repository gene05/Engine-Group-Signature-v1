function loadFunctionsClients(){
  if($('#body-group-signature .signature-container .document-validation .sigPad').length){

    if($('#body-group-signature .signature-container .sigPad input#typed_id').val()!=""){
      var typed_id = $('#body-group-signature .signature-container .sigPad input#typed_id').val();
      var name = $('#body-group-signature .client-document-content .document-validation .sigPad input#typed').val();
      var typed = '<div class="typed" id="typed-'+typed_id+'" data-id="'+typed_id+'" style="display: block;">'+name+'</div>';
      $('#body-group-signature .client-document-content .document-validation .sigPad .document-section-sign .sigWrapper div.typed').remove();
      $('#body-group-signature .client-document-content .document-validation .sigPad .document-section-sign .sigWrapper').append(typed);
      $('#body-group-signature .client-document-content .document-validation .sigPad .document-section-sign p').text('');
    }

    var signature = $('#body-group-signature .signature-container .document-validation .sigPad').signaturePad({
        lineWidth: 0,
        penColour: '#000',
        penWidth: 1,
        validateFields: false,
        displayOnly: true
    });

    if($('#body-group-signature .signature-container .document-validation .sigPad input.output').val()!=""){
      var st = $('#body-group-signature .signature-container .document-validation .sigPad input.output').val();
      var json = JSON.stringify(eval("("+st+")"));
      signature.regenerate(json);
      $('#body-group-signature .client-document-content .document-validation .sigPad .document-section-sign p').text('');
    }


    if($("#body-group-signature .client-document-content #date").val()=="") {
      setInputDate("#body-group-signature .client-document-content #date");
    }

    $('#body-group-signature .signature-container .document-section-sign').click(function(){
      popupSignature();
    });

    if($('#body-group-signature .display-message').text().indexOf("You must sign the document") >= 0){
      $('#body-group-signature .document-validation #accepted').prop('checked', true);
    }

  }

  $("#body-group-signature .signature-container .document-validation .sigPad .clearButton a").click(function() {
    if($('#body-group-signature .signature-container .document-section-sign p').hasClass('less-index')) {
      $('#body-group-signature .signature-container .document-section-sign p').removeClass('less-index');
    };
  });
};


function popupSignature(){
  var ply = new Ply({
      el: "<form class='sigPad'><ul class='sigNav'> <li class='drawIt'><a href='#draw-it' class='current' >Draw It</a></li><li class='typeIt'><a href='#type-it'>Type It</a></li> <li class='clearButton'><a href='#clear'>Clear</a></li>    </ul>  <div class='sig sigWrapper'>   <div class='signature-write hidden'> <input type='text' name='name' id='name' class='name' autocomplete='off' required> <div class='typed hoverSign' id='typed-1' data-id='1' ></div> <div class='typed' id='typed-2' data-id='2'></div><div class='typed' id='typed-3' data-id='3'></div><div class='typed' id='typed-4' data-id='4'></div><div class='typed' id='typed-5' data-id='5'></div><div class='typed' id='typed-6' data-id='6'></div>      </div> <div class='signature-draw'>  <canvas class='pad' width='250' height='74'></canvas>  </div>    <input type='hidden' name='output' id='output' class='output input-draw-sign' value='' title='You must draw your signature'>    </div>    <a href='#' class='button-sign' data-type-sign='draw' title='Sign'> Sign </a> <a href='#' class='submit btn btn-default' id='btn-cancel'>Cancel</a></form>", // HTML-content
      title: "Signature",
      effect: "fade",
      layer: {},
      overlay: {
          opacity: 0.6,
          backgroundColor: "#000"
      },
      flags: {
          closeBtn: true,
          bodyScroll: false,
          closeByEsc: true,
          closeByOverlay: true,
          hideLayerInStack: true,
          visibleOverlayInStack: false
      },
      onopen: function (ply) {setSigPadPopup();},
  });
  ply.open();
}

function setSigPadPopup(){
  var popup = $('#body-group-signature .ply-inside .sigPad').signaturePad({
    lineWidth: 0,
    penColour: 'black',
    penWidth: 1,
    validateFields: false,
    defaultAction: 'drawIt',
    penCap: 'square'
  });
  regenerateSignature(popup);
  clickEventsInSign(popup);
}

function clickEventsInSign(popup) {
  $('#body-group-signature .ply-inside .sigPad .typeIt').click(function(){
   setSignWrite();
  });

  $('#body-group-signature .ply-inside .sigPad .drawIt').click(function(){
    regenerateSignature(popup);
    setSignDraw();
  });

  $('#body-group-signature .ply-inside .sigPad .signature-write .typed').click(function(){
    setSelectTypeSignWrite(this);
  });

  $('#body-group-signature .ply-inside .sigPad .button-sign').click(function(){
    setSign(this);
  });

  $("#body-group-signature .ply-layer .sigPad #btn-cancel").click(function() {
    closeDialog(this);
  });
}

function setSign(obj){
  var sign_type = $(obj).attr('data-type-sign');
  var $myForm =  $(obj).parent();
  if(sign_type=='write' && !$myForm[0].checkValidity()){
    $('#body-group-signature .ply-inside .sigPad input.name').focus();
    $myForm[0].reportValidity();
  }else if(sign_type=='draw' && $('input.output', $myForm).val()==""){
    $('#body-group-signature .ply-inside .sigPad .signature-draw').addClass("hoverCanvas").delay(3200).queue(function(){
      $(obj).removeClass("hoverCanvas").dequeue();
    });
  }else{
    regenerateSignInForm(obj, sign_type);
    closeDialog(obj);
  }
}

function closeDialog(obj){
  $('div.ply-x', $(obj).parents().eq(3)).click();
}

function setSelectTypeSignWrite(obj) {
  $('#body-group-signature .ply-inside .sigPad .signature-write .typed').removeClass('hoverSign');
  $(obj).addClass('hoverSign');
}

function setSignWrite() {
  typed_id = $('#body-group-signature .signature-container .sigPad input#typed_id').val();
  if(typed_id!=""){
    selector = $('#body-group-signature .ply-inside .sigPad #typed-'+typed_id);
    setSelectTypeSignWrite(selector);
  }
  var name = $('#body-group-signature .client-document-content .sigPad .field-signature input#name').val();
  var set_write_signature = $('#body-group-signature .client-document-content .sigPad .sigWrapper .typed').text();
  var passenger_name = set_write_signature!="" ? set_write_signature : name;
  $('#body-group-signature .ply-inside .sigPad .button-sign').attr('data-type-sign', 'write');
  $('#body-group-signature .ply-inside .sigPad .signature-write').removeClass('hidden');
  $('#body-group-signature .ply-inside .sigPad .signature-draw').addClass('hidden');
  $('#body-group-signature .ply-inside .sigPad input.name').val(passenger_name);
  $('#body-group-signature .ply-inside .sigPad .sigWrapper .typed').text(passenger_name)
}

function setSignDraw() {
  $('#body-group-signature .ply-inside .sigPad .button-sign').attr('data-type-sign', 'draw');
  $('#body-group-signature .ply-inside .sigPad .signature-write').addClass('hidden');
  $('#body-group-signature .ply-inside .sigPad .signature-draw').removeClass('hidden');
  $('#body-group-signature .ply-inside .sigPad  input.name').val('');
}

function regenerateSignature(popup){
  if($('#body-group-signature .client-document-content .sigPad .sigWrapper input.output').val()!=""){
    var st = $('#body-group-signature .client-document-content .sigPad .sigWrapper input.output').val();
    var json = JSON.stringify(eval("(" + st + ")"));
    popup.regenerate(json);
  }else if($('#body-group-signature .client-document-content .sigPad .sigWrapper .typed').hasClass('hoverSign')){
    var typed_id = $('#body-group-signature .client-document-content .sigPad .sigWrapper .typed').attr('id');
    $('#body-group-signature .ply-inside .sigPad .signature-write #'+typed_id).addClass('hoverSign');
  }
}

function regenerateSignInForm(obj, sign_type){
  $('#body-group-signature .client-document-content .document-validation .sigPad .document-section-sign p').text('');
  $('#body-group-signature .client-document-content .document-validation .sigPad').signaturePad().clearCanvas();
  if(sign_type=='write'){
    regenerateWrite();
  }else{
    regenerateDraw(obj);
  }
}

function regenerateWrite() {
  typed = $('#body-group-signature .ply-inside .sigPad .signature-write .typed.hoverSign');
  typed_text = $('#body-group-signature .ply-inside .sigPad .signature-write input#name').val();
  typed_id = typed.attr('data-id');
  $('#body-group-signature .client-document-content .document-validation .sigPad .document-section-sign .sigWrapper div.typed').remove();
  $('#body-group-signature .client-document-content .document-validation .sigPad .document-section-sign .sigWrapper').append(typed);
  $('#body-group-signature .client-document-content .document-validation .sigPad').signaturePad({displayOnly: true});
  $('#body-group-signature .client-document-content .document-validation .sigPad input#typed').val(typed_text);
  $('#body-group-signature .client-document-content .document-validation .sigPad input#typed_id').val(typed_id);
}

function regenerateDraw(obj) {
  var st = $('input.output', $(obj).parent()).val();
  var json = JSON.stringify(eval("(" + st + ")"));
  $('#body-group-signature .client-document-content .document-validation .sigPad').signaturePad({displayOnly: true}).regenerate(json);
  $('#body-group-signature .client-document-content .document-validation .sigPad input#typed_id').val('');
  $('#body-group-signature .client-document-content .document-validation .sigPad input#typed').val('');

}

function existSignature(){
  if($('#body-group-signature .signature-container .document-section-sign .sigWrapper input').val().length>0){
    $('#body-group-signature .signature-container .document-section-sign p').addClass('less-index');      
  }else{
    $('#body-group-signature .signature-container .document-section-sign p').removeClass('less-index');      
  }
}

function setInputDate(_id){
  var _dat = document.querySelector(_id);
  var today = new Date(),
      d = today.getDate(),
      m = today.getMonth()+1, 
      y = today.getFullYear(),
      data;

  if(d < 10){
    d = "0"+d;
  };
  if(m < 10){
    m = "0"+m;
  };

  data = y+"-"+m+"-"+d;
  _dat.value = data;
};


