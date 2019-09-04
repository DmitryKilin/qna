$(document).on('turbolinks:load', function(){
    $('.question').on('click','.edit-question-link', function(e){
        e.preventDefault();
        $(this).hide();
        $('form#edit-question').removeClass('hidden');
    })

    // App.cable.subscriptions.create('QuestionChannel', {
    //     connected: function () {
    //         return this.perform('follow');
    //     },
    //     received: function (data) {
    //         console.log(data);
    //         $('.questions').append(data);
    //     }
    // });
});
