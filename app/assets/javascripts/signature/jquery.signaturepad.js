(function ($) {

function SignaturePad (selector, options) {
  var self = this
  , settings = $.extend({}, $.fn.signaturePad.defaults, options)
  , context = $(selector)
  , canvas = $(settings.canvas, context)
  , element = canvas.get(0)
  , canvasContext = null
  , previous = {'x': null, 'y': null}
  , output = []
  , mouseLeaveTimeout = false
  , mouseButtonDown = false
  , touchable = false
  , eventsBound = false
  , typeItDefaultFontSize = 30
  , typeItCurrentFontSize = typeItDefaultFontSize
  , typeItNumChars = 0

  function clearMouseLeaveTimeout () {
    clearTimeout(mouseLeaveTimeout)
    mouseLeaveTimeout = false
    mouseButtonDown = false
  }

  function drawLine (e, newYOffset) {
    var offset, newX, newY

    e.preventDefault()

    offset = $(e.target).offset()

    clearTimeout(mouseLeaveTimeout)
    mouseLeaveTimeout = false

    if (typeof e.targetTouches !== 'undefined') {
      newX = Math.floor(e.targetTouches[0].pageX - offset.left)
      newY = Math.floor(e.targetTouches[0].pageY - offset.top)
    } else {
      newX = Math.floor(e.pageX - offset.left)
      newY = Math.floor(e.pageY - offset.top)
    }

    if (previous.x === newX && previous.y === newY)
      return true

    if (previous.x === null)
      previous.x = newX

    if (previous.y === null)
      previous.y = newY

    if (newYOffset)
      newY += newYOffset

    canvasContext.beginPath()
    canvasContext.moveTo(previous.x, previous.y)
    canvasContext.lineTo(newX, newY)
    canvasContext.lineCap = settings.penCap
    canvasContext.stroke()
    canvasContext.closePath()

    output.push({
      'lx' : newX
      , 'ly' : newY
      , 'mx' : previous.x
      , 'my' : previous.y
    })

    previous.x = newX
    previous.y = newY

    if (settings.onDraw && typeof settings.onDraw === 'function')
      settings.onDraw.apply(self)
  }

  function stopDrawingWrapper () {
    stopDrawing()
  }

  function stopDrawing (e) {
    if (!!e) {
      drawLine(e, 1)
    } else {
      if (touchable) {
        canvas.each(function () {
          this.removeEventListener('touchmove', drawLine)
        })
      } else {
        canvas.unbind('mousemove.signaturepad')
      }

      if (output.length > 0 && settings.onDrawEnd && typeof settings.onDrawEnd === 'function')
        settings.onDrawEnd.apply(self)
    }

    previous.x = null
    previous.y = null

    if (settings.output && output.length > 0)
      $(settings.output, context).val(JSON.stringify(output))
  }

  function drawSigLine () {
    if (!settings.lineWidth)
      return false

    canvasContext.beginPath()
    canvasContext.lineWidth = settings.lineWidth
    canvasContext.strokeStyle = settings.lineColour
    canvasContext.moveTo(settings.lineMargin, settings.lineTop)
    canvasContext.lineTo(element.width - settings.lineMargin, settings.lineTop)
    canvasContext.stroke()
    canvasContext.closePath()
  }

  function clearCanvas () {
    canvasContext.clearRect(0, 0, element.width, element.height)
    canvasContext.fillStyle = settings.bgColour
    canvasContext.fillRect(0, 0, element.width, element.height)

    if (!settings.displayOnly)
      drawSigLine()

    canvasContext.lineWidth = settings.penWidth
    canvasContext.strokeStyle = settings.penColour

    $(settings.output, context).val('')
    output = []

    stopDrawing()
  }

  function onMouseMove(e, o) {
    if (previous.x == null) {
      drawLine(e, 1)
    } else {
      drawLine(e, o)
    }
  }

  function startDrawing (e, touchObject) {
    if (touchable) {
      touchObject.addEventListener('touchmove', onMouseMove, false)
    } else {
      canvas.bind('mousemove.signaturepad', onMouseMove)
    }
    drawLine(e, 1)
  }

  function disableCanvas () {
    eventsBound = false

    canvas.each(function () {
      if (this.removeEventListener) {
        this.removeEventListener('touchend', stopDrawingWrapper)
        this.removeEventListener('touchcancel', stopDrawingWrapper)
        this.removeEventListener('touchmove', drawLine)
      }

      if (this.ontouchstart)
        this.ontouchstart = null;
    })

    $(document).unbind('mouseup.signaturepad')
    canvas.unbind('mousedown.signaturepad')
    canvas.unbind('mousemove.signaturepad')
    canvas.unbind('mouseleave.signaturepad')

    $(settings.clear, context).unbind('click.signaturepad')
  }

  function initDrawEvents (e) {
    if (eventsBound)
      return false

    eventsBound = true

    $('input').blur();

    if (typeof e.targetTouches !== 'undefined')
      touchable = true

    if (touchable) {
      canvas.each(function () {
        this.addEventListener('touchend', stopDrawingWrapper, false)
        this.addEventListener('touchcancel', stopDrawingWrapper, false)
      })

      canvas.unbind('mousedown.signaturepad')
    } else {
      $(document).bind('mouseup.signaturepad', function () {
        if (mouseButtonDown) {
          stopDrawing()
          clearMouseLeaveTimeout()
        }
      })
      canvas.bind('mouseleave.signaturepad', function (e) {
        if (mouseButtonDown) stopDrawing(e)

        if (mouseButtonDown && !mouseLeaveTimeout) {
          mouseLeaveTimeout = setTimeout(function () {
            stopDrawing()
            clearMouseLeaveTimeout()
          }, 500)
        }
      })

      canvas.each(function () {
        this.ontouchstart = null
      })
    }
  }

  function drawIt () {
    $(settings.typed, context).hide()
    clearCanvas()

    canvas.each(function () {
      this.ontouchstart = function (e) {
        e.preventDefault()
        mouseButtonDown = true
        initDrawEvents(e)
        startDrawing(e, this)
      }
    })

    canvas.bind('mousedown.signaturepad', function (e) {
      e.preventDefault()
      if (e.which > 1) return false
      mouseButtonDown = true
      initDrawEvents(e)
      startDrawing(e)
    })

    $(settings.clear, context).bind('click.signaturepad', function (e) { e.preventDefault(); clearCanvas() })
    $(settings.typeIt, context).bind('click.signaturepad', function (e) { e.preventDefault(); typeIt() })
    $(settings.drawIt, context).unbind('click.signaturepad')
    $(settings.drawIt, context).bind('click.signaturepad', function (e) { e.preventDefault() })
    $(settings.typeIt, context).removeClass(settings.currentClass)
    $(settings.drawIt, context).addClass(settings.currentClass)
    $(settings.sig, context).addClass(settings.currentClass)
    $(settings.typeItDesc, context).hide()
    $(settings.drawItDesc, context).show()
    $(settings.clear, context).show()
  }

  function typeIt () {
    clearCanvas()
    disableCanvas()
    $(settings.typed, context).show()
    $(settings.drawIt, context).bind('click.signaturepad', function (e) { e.preventDefault(); drawIt() })
    $(settings.typeIt, context).unbind('click.signaturepad')
    $(settings.typeIt, context).bind('click.signaturepad', function (e) { e.preventDefault() })
    $(settings.output, context).val('')
    $(settings.drawIt, context).removeClass(settings.currentClass)
    $(settings.typeIt, context).addClass(settings.currentClass)
    $(settings.sig, context).removeClass(settings.currentClass)
    $(settings.drawItDesc, context).hide()
    $(settings.clear, context).hide()
    $(settings.typeItDesc, context).show()

    typeItCurrentFontSize = typeItDefaultFontSize = $(settings.typed, context).css('font-size').replace(/px/, '')
  }

  function type (val) {
    var typed = $(settings.typed, context)
      , cleanedVal = $.trim(val.replace(/>/g, '&gt;').replace(/</g, '&lt;'))
      , oldLength = typeItNumChars
      , edgeOffset = typeItCurrentFontSize * 0.5

    typeItNumChars = cleanedVal.length
    typed.html(cleanedVal)

    if (!cleanedVal) {
      typed.css('font-size', typeItDefaultFontSize + 'px')
      return
    }

    if (typeItNumChars > oldLength && typed.outerWidth() > element.width) {
      while (typed.outerWidth() > element.width) {
        typeItCurrentFontSize--
        typed.css('font-size', typeItCurrentFontSize + 'px')
      }
    }

    if (typeItNumChars < oldLength && typed.outerWidth() + edgeOffset < element.width && typeItCurrentFontSize < typeItDefaultFontSize) {
      while (typed.outerWidth() + edgeOffset < element.width && typeItCurrentFontSize < typeItDefaultFontSize) {
        typeItCurrentFontSize++
        typed.css('font-size', typeItCurrentFontSize + 'px')
      }
    }
  }

  function onBeforeValidate (context, settings) {
    $('p.' + settings.errorClass, context).remove()
    context.removeClass(settings.errorClass)
    $('input, label', context).removeClass(settings.errorClass)
  }

  function onFormError (errors, context, settings) {
    if (errors.nameInvalid) {
      context.prepend(['<p class="', settings.errorClass, '">', settings.errorMessage, '</p>'].join(''))
      $(settings.name, context).focus()
      $(settings.name, context).addClass(settings.errorClass)
      $('label[for=' + $(settings.name).attr('id') + ']', context).addClass(settings.errorClass)
    }

    if (errors.drawInvalid)
      context.prepend(['<p class="', settings.errorClass, '">', settings.errorMessageDraw, '</p>'].join(''))
  }

  function validateForm () {
    var valid = true
      , errors = {drawInvalid: false, nameInvalid: false}
      , onBeforeArguments = [context, settings]
      , onErrorArguments = [errors, context, settings]

    if (settings.onBeforeValidate && typeof settings.onBeforeValidate === 'function') {
      settings.onBeforeValidate.apply(self,onBeforeArguments)
    } else {
      onBeforeValidate.apply(self, onBeforeArguments)
    }

    if (settings.drawOnly && output.length < 1) {
      errors.drawInvalid = true
      valid = false
    }

    if ($(settings.name, context).val() === '') {
      errors.nameInvalid = true
      valid = false
    }

    if (settings.onFormError && typeof settings.onFormError === 'function') {
      settings.onFormError.apply(self,onErrorArguments)
    } else {
      onFormError.apply(self, onErrorArguments)
    }

    return valid
  }

  function drawSignature (paths, context, saveOutput) {
    for(var i in paths) {
      if (typeof paths[i] === 'object') {
        context.beginPath()
        context.moveTo(paths[i].mx, paths[i].my)
        context.lineTo(paths[i].lx, paths[i].ly)
        context.lineCap = settings.penCap
        context.stroke()
        context.closePath()

        if (saveOutput) {
          output.push({
            'lx' : paths[i].lx
            , 'ly' : paths[i].ly
            , 'mx' : paths[i].mx
            , 'my' : paths[i].my
          })
        }
      }
    }
  }

  function init () {
    if (parseFloat(((/CPU.+OS ([0-9_]{3}).*AppleWebkit.*Mobile/i.exec(navigator.userAgent)) || [0,'4_2'])[1].replace('_','.')) < 4.1) {
       $.fn.Oldoffset = $.fn.offset;
       $.fn.offset = function () {
          var result = $(this).Oldoffset()
          result.top -= window.scrollY
          result.left -= window.scrollX

          return result
       }
    }

    $(settings.typed, context).bind('selectstart.signaturepad', function (e) { return $(e.target).is(':input') })
    canvas.bind('selectstart.signaturepad', function (e) { return $(e.target).is(':input') })

    if (!element.getContext && FlashCanvas)
      FlashCanvas.initElement(element)

    if (element.getContext) {
      canvasContext = element.getContext('2d')

      $(settings.sig, context).show()

      if (!settings.displayOnly) {
        if (!settings.drawOnly) {
          $(settings.name, context).bind('keyup.signaturepad', function () {
            type($(this).val())
          })

          $(settings.name, context).bind('blur.signaturepad', function () {
            type($(this).val())
          })

          $(settings.drawIt, context).bind('click.signaturepad', function (e) {
            e.preventDefault()
            drawIt()
          })
        }

        if (settings.drawOnly || settings.defaultAction === 'drawIt') {
          drawIt()
        } else {
          typeIt()
        }

        if (settings.validateFields) {
          if ($(selector).is('form')) {
            $(selector).bind('submit.signaturepad', function () { return validateForm() })
          } else {
            $(selector).parents('form').bind('submit.signaturepad', function () { return validateForm() })
          }
        }

        $(settings.sigNav, context).show()
      }
    }
  }

  $.extend(self, {
    signaturePad : '{{version}}'
    , init : function () { init() }
    , updateOptions : function (options) {
      $.extend(settings, options)
    }
    , regenerate : function (paths) {
      self.clearCanvas()
      $(settings.typed, context).hide()
      if (typeof paths === 'string')
        paths = JSON.parse(paths)
      drawSignature(paths, canvasContext, true)
      if (settings.output && $(settings.output, context).length > 0)
        $(settings.output, context).val(JSON.stringify(output))
    }
    , clearCanvas : function () { clearCanvas() }
    , getSignature : function () { return output }
    , getSignatureString : function () { return JSON.stringify(output) }
    , getSignatureImage : function () {
      var tmpCanvas = document.createElement('canvas')
        , tmpContext = null
        , data = null

      tmpCanvas.style.position = 'absolute'
      tmpCanvas.style.top = '-999em'
      tmpCanvas.width = element.width
      tmpCanvas.height = element.height
      document.body.appendChild(tmpCanvas)

      if (!tmpCanvas.getContext && FlashCanvas)
        FlashCanvas.initElement(tmpCanvas)

      tmpContext = tmpCanvas.getContext('2d')

      tmpContext.fillStyle = settings.bgColour
      tmpContext.fillRect(0, 0, element.width, element.height)
      tmpContext.lineWidth = settings.penWidth
      tmpContext.strokeStyle = settings.penColour

      drawSignature(output, tmpContext)
      data = tmpCanvas.toDataURL.apply(tmpCanvas, arguments)

      document.body.removeChild(tmpCanvas)
      tmpCanvas = null

      return data
    }
    , validateForm : function () { return validateForm() }
  })
}

$.fn.signaturePad = function (options) {
  var api = null

  this.each(function () {
    if (!$.data(this, 'plugin-signaturePad')) {
      api = new SignaturePad(this, options)
      api.init()
      $.data(this, 'plugin-signaturePad', api)
    } else {
      api = $.data(this, 'plugin-signaturePad')
      api.updateOptions(options)
    }
  })

  return api
}

$.fn.signaturePad.defaults = {
  defaultAction : 'typeIt' // What action should be highlighted first: typeIt or drawIt
  , displayOnly : false // Initialize canvas for signature display only; ignore buttons and inputs
  , drawOnly : false // Whether the to allow a typed signature or not
  , canvas : 'canvas' // Selector for selecting the canvas element
  , sig : '.sig' // Parts of the signature form that require Javascript (hidden by default)
  , sigNav : '.sigNav' // The TypeIt/DrawIt navigation (hidden by default)
  , bgColour : '#ffffff' // The colour fill for the background of the canvas; or transparent
  , penColour : '#145394' // Colour of the drawing ink
  , penWidth : 2 // Thickness of the pen
  , penCap : 'round' // Determines how the end points of each line are drawn (values: 'butt', 'round', 'square')
  , lineColour : '#ccc' // Colour of the signature line
  , lineWidth : 2 // Thickness of the signature line
  , lineMargin : 5 // Margin on right and left of signature line
  , lineTop : 35 // Distance to draw the line from the top
  , name : '.name' // The input field for typing a name
  , typed : '.typed' // The Html element to accept the printed name
  , clear : '.clearButton' // Button for clearing the canvas
  , typeIt : '.typeIt a' // Button to trigger name typing actions (current by default)
  , drawIt : '.drawIt a' // Button to trigger name drawing actions
  , typeItDesc : '.typeItDesc' // The description for TypeIt actions
  , drawItDesc : '.drawItDesc' // The description for DrawIt actions (hidden by default)
  , output : '.output' // The hidden input field for remembering line coordinates
  , currentClass : 'current' // The class used to mark items as being currently active
  , validateFields : true // Whether the name, draw fields should be validated
  , errorClass : 'error' // The class applied to the new error Html element
  , errorMessage : 'Please enter your name' // The error message displayed on invalid submission
  , errorMessageDraw : 'Please sign the document' // The error message displayed when drawOnly and no signature is drawn
  , onBeforeValidate : null // Pass a callback to be used instead of the built-in function
  , onFormError : null // Pass a callback to be used instead of the built-in function
  , onDraw : null // Pass a callback to be used to capture the drawing process
  , onDrawEnd : null // Pass a callback to be exectued after the drawing process
}

}(jQuery));
