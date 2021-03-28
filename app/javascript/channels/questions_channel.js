import consumer from "./consumer"

if (window.questionChannel == undefined ) {
  window.questionChannel = consumer.subscriptions.create("QuestionsChannel", {
    connected() {
      console.log("connected")
      this.perform('subscribed')
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      let question = ""
      // $.each(data.questions_titles, function(index, value) {
        question = "<p>" + "<a href=" + "/questions/" + data.id + ">" + data.title +"</a>" + "</p>"
      // })
      console.log(question)
      $('.questions').append(question)
      // Called when there's incoming data on the websocket for this channel
    }
  });
}
