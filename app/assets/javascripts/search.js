$(document).on('turbolinks:load', function(){
    $('form#search').on("ajax:success", function(e) {
        console.log(e);
    })
});