$(function(){
  function buildHTML(message) {
    var content = message.content ? `${ message.content }` : "";
    var image = message.image ? `<img src= ${ message.image }>` : "";
    var html = `<div class = "talk">
                   <div class = "talk__user-info">
                      <div class = "talk__user-info__name">
                          ${message.user_name}
                      </div>
                      <div class = "talk__user-info__time">
                          ${message.created_at}
                      </div>
                   </div>
                   <div class = "talk__text">
                      <p class = "talk__text__content">
                         ${content}
                      </p>
                      <img class = "talk__text__image">
                         ${image}
                      </p>
                   </div>
                 </div>`
                
    return html;
  }

  $('#new_message').on('submit', function(e){
    e.preventDefault();
    var formData = new FormData(this);
    var url = $(this).attr('action')
    $.ajax({
      url: url,
      type: "POST",
      data: formData,
      dataType: 'json',
      processData: false,
      contentType: false
  })
  .done(function(data){
    var html = buildHTML(data);
    $('.talks').append(html)
    $("form")[0].reset();
    $('.talks').animate({ scrollTop: $('.talks')[0].scrollHeight});
  })
  .fail(function(){
    alert('入力してください');
  })
  return false;
})
});