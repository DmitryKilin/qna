$(document).on('turbolinks:load', function(){
    $('form#search').on("ajax:success", function(e) {
        var search_result = e.detail[0];

        clearUlElements();
        if (search_result) {
            var result_length = search_result.length;
            for (var i = 0; i < result_length; i++) {
                index = Object.keys(search_result[i])[0];
                elementId = 'ul#' + index;
                link = search_result[i][index].link
                elementlink = createLiTag(link);
                $(elementId).append(elementlink);
            }
        }
    })
});

function createLiTag(link) {
    return '<li><a href="' + link +'" target="_blank">'+ link + '</a></li>'
}

function clearUlElements() {
    $('ul').empty()
}