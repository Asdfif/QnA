$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e) {
    e.preventDefault()
    $(this).hide()
    const answerId = $(this).data('answerId')
    $('form#edit-answer-' + answerId).removeClass('hidden')
  })

  // $('form.new-answer')
  // .on('ajax:success', function(e) {
  //   let answer_and_links = e.detail[0]
  //   $('.answers').append('<p>' + answer_and_links.answer.body + '</p>')

  //   if (answer_and_links.links == []) {
  //   } else {
  //     let links = ''
  //     $.each(answer_and_links.links, function(index, value) {
  //       links = links + '<p>' + '<a href=' + answer_and_links.links[index].url + '>' + answer_and_links.links[index].name + '</p>'
  //     })
  //     $('.answers').append(links)
  //   }

  //   if (answer_and_links.files ==[]) {
  //   } else {
  //     let files = ''
  //     $.each(answer_and_links.files, function(index, value) {
  //       files = files + '<p>' + '<a href=' + value[1] + '>' + value[0] + '</p>'
  //     })
  //     $('.answers').append(files)
  //   }
  // })
  //   .on('ajax:error', function(e) {
  //     $('.answer-errors').append('<p>error(s) detected:</p>')
  //     let errors = e.detail[0]
  //     $.each(errors, function(index, value) {
  //       $('.answer-errors').append('<p>' + value + '</p>')
  //     })
  //   })
})