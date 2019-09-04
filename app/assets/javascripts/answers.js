$(document).on('turbolinks:load', function(){
    $('.answers').on('click','.edit-answer-link', function(e){
       e.preventDefault();
       $(this).hide();
       var answerId = $(this).data('answer-id');
       $('form#edit-answer-' + answerId).removeClass('hidden');
    });

    App.cable.subscriptions.create('AnswerChannel', {
        connected: function() {
            var questionId = $('.question').data('question-id');
            return this.perform('follow', {question_id: questionId});
        },
        received: function (data) {

           if (gon.user_id != data.answer.user_id) {
             var newAnswer = JST['templates/answer']({
                 answer: data.answer,
                 links: data.links,
                 files: data.files
             });
             $('.answers').append(newAnswer);

             $('.poll').on('ajax:success', '.vote', function (e) {
                 var xhr = e.detail[0];
                 var votableType = xhr['votableType'];
                 var votableId = xhr['votableId'];
                 var pollResult = xhr['pollResult'];

                 var elID = '#amount' + '-' + votableType + '-' + votableId;
                 $( elID ).html(pollResult);
               });
           }
        }
    })
});
