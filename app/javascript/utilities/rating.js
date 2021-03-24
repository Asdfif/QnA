$(document).on('turbolinks:load', function(){
  $('.cancel-vote').on('ajax:success', function(e) {
    e.preventDefault()
    const rating = e.detail[0][0]
    const klass = e.detail[0][1]
    const id = e.detail[0][2]
    $('div[data-' + klass + '-id=' + id + ']').find('.rating-errors').empty()
    $('div[data-' + klass + '-id=' + id + ']').find('.rating-result').html('Rating: ' + rating)
    $(this).addClass('hidden')
    $('div[data-' + klass + '-id=' + id + ']').find('.vote').removeClass('hidden')
 })

  $('.vote').on('ajax:success', function(e) {
    e.preventDefault()
    const rating = e.detail[0][0]
    const klass = e.detail[0][1]
    const id = e.detail[0][2]
    $('div[data-' + klass + '-id=' + id + ']').find('.rating-errors').empty()
    $('div[data-' + klass + '-id=' + id + ']').find('.rating-result').html('Rating: ' + rating)
    $('.vote').addClass('hidden')
    $('div[data-' + klass + '-id=' + id + ']').find('.cancel-vote').removeClass('hidden')
 })
  .on('ajax:error', function(e) {
      const errors = e.detail[0][0]
      const klass = e.detail[0][1]
      const id = e.detail[0][2]
      $('div[data-' + klass + '-id=' + id + ']').find('.rating-errors').html('<p>error(s) detected:</p>')
      $.each(errors, function(index, value) {
        $('div[data-' + klass + '-id=' + id + ']').find('.rating-errors').html('<p>' + value + '</p>')
      })
    })
})
