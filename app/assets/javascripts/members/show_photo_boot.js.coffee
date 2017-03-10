#= require util/letterbox_to_parent
#= require ./show_photo_edit

fileChooser = null

submitAvatarForm = ->
  maskEl = $('#editImage')
  maskData = maskEl.photo_edit('reposition')
  maskData = maskEl.photo_edit('naturalData')
  $('#photoTop').val    maskData.top
  $('#photoLeft').val   maskData.left
  $('#photoHeight').val maskData.height
  $('#photoWidth').val  maskData.width
  $('#avatarForm').submit()

setupCropEdit = ->
  increment = 10
  editImage = $('#editImage')
  editImage.letterbox_to_parent()
  editImage.photo_edit()
  $('.cropMask').draggable()
  $('#cropExpand').click (ev)=>
    ev?.preventDefault()
    editImage.photo_edit('expandHeight', increment)
  $('#cropShrink').click =>
    ev?.preventDefault()
    editImage.photo_edit('shrinkHeight', increment)

loadImage = (type, ev)->
  container = $("#" + type + "Container")
  image = new Image()
  image.id    = "#{type}Image"
  image.src   = ev.target.result
  image.class = "img-responsive"
  container.innerHTML = ""
  container[0].appendChild image

displayImage = (ev)->
  ev?.preventDefault()
  file = fileChooser[0].files[0]
  reader = new FileReader()
  reader.onload = (ev)->
    $('.avEdit').show()
    loadImage("edit", ev)
    $('#editImage').show().load      -> setupCropEdit()
    $('#avatarSaveBtn').show().click -> submitAvatarForm()
  reader.readAsDataURL file

$(document).ready ->
  return if touchDevice()
  editContainer = $('#editContainer')
  fileChooser   = $('#avatarPhoto')
  fileChooser.change -> displayImage()
  $('#userAvatar').addClass('editable-img').css('max-height', '110px')
  $('#addNew').click (ev)->
    ev?.preventDefault()
    fileChooser.click()
  $('#userAvatar').click    -> $('#myModal').modal()
