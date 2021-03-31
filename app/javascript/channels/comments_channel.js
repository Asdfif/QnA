import consumer from "./consumer"

$(document).on('turbolinks:load', function(){
  const question = $('.question')

  if (question.length != 0 ) {
    let questionId = question.data('questionId')
    let template = require('./templates/comments.hbs')

    if (window.commentChannel == undefined ) {
      window.commentChannel = consumer.subscriptions.create({channel: "CommentsChannel", question_id: questionId}, {
        connected() {
          console.log("connected comments")
          this.perform('subscribed')
          // Called when the subscription is ready for use on the server
        },

        disconnected() {
          // Called when the subscription has been terminated by the server
        },

        received(data) {
          console.log("received comments")

          if (gon.user_id != data.author_id) {
            if (data.commentable_klass == 'answer') {
              $('[data-answer-id=' + data.commentable_id + ']')
                .find('.comments')
                .append(template(data))
            } else {
              $('[data-question-id=' + data.commentable_id + ']')
                .find('.comments')
                .append(template(data))
            }
          }
        }
      })
    }
  }
})

