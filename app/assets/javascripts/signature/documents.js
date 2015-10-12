function loadFunctionsDocuments() {
  if($('#body-group-signature .new-document-container #summernote').length){
    setSummernote();
    setButtonInsertNameEditor();
  }

  $("#body-group-signature .form-new-document #btn-add-document").click(function() {
    validateDocument($(this).data('action'));
  });
};

function setSummernote(){
  $('#body-group-signature .new-document-container #summernote').summernote({
    height: 300,
    minHeight: null,
    maxHeight: null,
    focus: true,
  });
}

function setButtonInsertNameEditor(selector){
  if(!$('#body-group-signature '+selector+' .note-toolbar #insertName').length){
    addButtonNameEditor(selector);
  }
  $('#insertName').click(function (event) {
    $('#body-group-signature '+selector+' #summernote').summernote("insertText", '{{@NAME@}}');
  });
  closeDocumentPopup(selector);
}

function addButtonNameEditor(selector){
    var new_button = '<button type="button" class="btn btn-default btn-sm btn-small" title="" id="insertName" data-event="intert_name" tabindex="-1" data-name="intert_name" data-original-title="Insert Name">Insert Name</button>';
    $('#body-group-signature '+selector+' .note-toolbar').append('<div class="note-view btn-group">' + new_button + '</div>');
    $('#body-group-signature '+selector+' .note-toolbar #insertName').parent().append('<div class="signature-tooltip-content-message">Insert a section for the signer name</div>');
    $('#body-group-signature '+selector+' .note-toolbar #insertName').parent().addClass('note-toolbar-add');
}

function closeDocumentPopup(selector) {
  $('#body-group-signature '+selector+' .b-close').click(function (event) {
    $('#body-group-signature '+selector+' #summernote').code(''); 
  });
}

function validateDocument(action){
  var selector_title = $("#body-group-signature #"+action+"-document-popup .form-new-document input#document_title");
  var selector_content = $("#body-group-signature #"+action+"-document-popup .form-new-document #summernote");
  var document_title = selector_title.val();
  var document_content = selector_content.code();
  if(document_title && document_title!="" && document_content && document_content!= ""){
    if(action == 'new'){
      addDocument(document_title, document_content);
    }else if(action == 'edit'){
      editDocument(document_title, document_content);
    }
  }else{
    var field = fieldName(selector_title, selector_content);
    appendMessage('red', '#'+action+'-document-popup', 'The field '+field+' must not be empty');
  }
}

function fieldName(selector_title, selector_content){
  if(!selector_title.val()){
    selector_title.focus();
    return "Title";
  }else if(!selector_content.code()){
    selector_content.focus();
    return "Document";
  }
}

function addDocument(document_title, document_content){
  document_data = {
    'document[title]': document_title,
    'document[content]':  document_content
  }
  $.post("/signature/documents", document_data, function( data ) {
    if(data.status == true){
      $('#body-group-signature #new-document-popup .b-close').click();
      window.location.href="/signature/documents?success=added";
    }
  });
}

function editDocument(document_title, document_content){
  var id = $("#body-group-signature .edit-document-container #document-id").text();
  document_data = {
    'document[title]': document_title,
    'document[content]': document_content
  }
  $.ajax({
    method: "PUT",
    url: "/signature/documents/"+id,
    data: document_data,
    success: function(result) {
      $('#body-group-signature #edit-document-popup .b-close').click();
      window.location.href="/signature/documents?success=updated";
    }
  });
}

function addADocument(){
  setSummernote();
  setButtonInsertNameEditor('#new-document-popup');
  $('#body-group-signature #new-document-popup').css("width", ($(window).width()-100)+"px");
  $('#body-group-signature #new-document-popup').css("height", ($(window).height()-$('#body-group-signature .signature-header').height())+"px");
    $('#new-document-popup').bPopup({
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

function editThisDocument(id){
  $('#body-group-signature #edit-document-popup').css("width", ($(window).width()-100)+"px");
  $('#body-group-signature #edit-document-popup').css("height", ($(window).height()-$('#body-group-signature .signature-header').height())+"px");
    $($('#edit-document-popup')).bPopup({
      speed: 350,
      followSpeed: 1500 ,
      position: [100, 'auto'],
      positionStyle: 'fixed',
      follow: [true, false],
      modalColor: 'black',
      transition: 'slideBack',
      transitionClose: 'slideBack',
      onOpen: function(){
        $('.edit-document-container #summernote').summernote({
          height: 300,                 // set editor height
          minHeight: null,             // set minimum height of editor
          maxHeight: null,             // set maximum height of editor
          focus: true,                 // set focus to editable area after initializing summernote
        });
        setButtonInsertNameEditor('#edit-document-popup');
        $.get("/signature/set_document_summernote/"+id, function( data ) {
          if(data.status == true){
            $("#body-group-signature .edit-document-container input#document_title").val(data.document.title);
            $("#body-group-signature .edit-document-container #summernote").code(data.document.content);
            $("#body-group-signature .edit-document-container #document-id").text(data.document.id);
          }
        });
      }
    });
}


