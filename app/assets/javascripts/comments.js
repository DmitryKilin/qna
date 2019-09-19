$(document).on('turbolinks:load', function () {
        $('form.new-comment')
            .on('ajax:error', function (e) {
                // var errors = e.detail[0];
                var $divErrors = $('.notifications');
                var errorBanner = JST ['templates/error']({errors: e.detail[0]});

                $divErrors.children().remove();
                $divErrors.prepend(errorBanner);
            });
        App.cable.subscriptions.create('CommentChannel', {
            connected: function() {
                return this.perform('follow')
            },
            received: appendComment
        })
});

function appendComment(data) {
    var $divComments = $('div[data-' + data['commented_resource'] + '-id="' + data['commented_resource_id'] + '"]' +
                            ' .comments .comments-list');

    $('.notifications').children().remove();

    $divComments.append(
        JST ['templates/comment'] ({comment: data})
    );
}