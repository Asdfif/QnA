$(document).on('turbolinks:load', function(){
  $('.cancel-vote').on('ajax:success', function(e) {
    e.preventDefault()
    const data = e.detail[0]
    Rating(data)
    $(this).addClass('hidden')
    $('div[data-' + data.klass + '-id=' + data.id + ']').find('.vote').removeClass('hidden')
 })

  $('.vote').on('ajax:success', function(e) {
    e.preventDefault()
    const data = e.detail[0]
    Rating(data)
    $('.vote').addClass('hidden')
    $('div[data-' + data.klass + '-id=' + data.id + ']').find('.cancel-vote').removeClass('hidden')
 })
  .on('ajax:error', function(e) {
    const data = e.detail[0]
    const errors = data.errors
    const klass = data.klass
    const id = data.id
    $('div[data-' + klass + '-id=' + id + ']').find('.rating-errors').html('<p>error(s) detected:</p>')
    $.each(errors, function(index, value) {
      $('div[data-' + klass + '-id=' + id + ']').find('.rating-errors').html('<p>' + value + '</p>')
    })
  })

  function Rating(data) {
    const rating = data.rating
    const klass = data.klass
    const id = data.id
    $('div[data-' + klass + '-id=' + id + ']').find('.rating-errors').empty()
    $('div[data-' + klass + '-id=' + id + ']').find('.rating-result').html('Rating: ' + rating)
  }
})
