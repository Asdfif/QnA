import consumer from "./consumer"

$(document).on('turbolinks:load', function(){
  const answers = $('.answers')

  if (answers.length != 0 ) {
    let questionId = $('.question').data('questionId')
    let template = require('./templates/answers.hbs')

    console.log(questionId)
    if (window.answerChannel == undefined ) {
      window.answerChannel = consumer.subscriptions.create({channel: "AnswersChannel", question_id: questionId}, {
        connected() {
          console.log("connected answers")
          this.perform('subscribed')
          // Called when the subscription is ready for use on the server
        },

        disconnected() {
          // Called when the subscription has been terminated by the server
        },

        received(data) {
          console.log("received ")
          console.log("user id " + gon.user_id)
          console.log('author id ' + data.author_id)
          console.log('answer ' + data.answer)
          
          if (gon.user_id != data.author_id) {
            let files_links = "" 
            $.each(data.files, function(index, value) {
              files_links = files_links + "<p data-file-id=" + value[3] + ">" + "<a target=_blank href=" + value[1] + '">' + value[0] + "</a>" + "</p>"
            })
            data.files = files_links
            let links = "" 
            $.each(data.links, function(index, value) {
              console.log(value[1])
              links = links + "<li>" + "<a target=_blank href=" + value[1] + '">' + value[0] + "</a>" + "</li>"
            })
            data.files = files_links
            data.links = links
            $('.answers').append(template(data)) 
          }
          
          
          // answersList.html(data)
          // console.log('received')
          // Called when there's incoming data on the websocket for this channel
        }
      });
    }
  }
})

