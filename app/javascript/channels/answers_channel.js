import consumer from "./consumer"

$(document).on('turbolinks:load', function(){
  const answers = $('.answers')

  if (answers.length != 0 ) {
    let questionId = $('.question').data('questionId')
    let template = require('./templates/answers.hbs')

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
          console.log("received answer")

          if (gon.user_id != data.answer.user_id) {
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
        }
      })
    }
  }
})

