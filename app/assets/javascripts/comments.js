$(document).on('turbolinks:load', function () {
        $('form.new-comment')
            .on('ajax:error', function (e) {
                var errors = e.detail[0];
                var $divErrors = $('.notifications');

                $divErrors.children().remove();
                $divErrors.prepend(
                    '<div class="alert alert-danger alert-dismissible fade show"' +
                        '<stong>' + errors.length + ' error(s) detected: ' + '</stong>' +
                        '<ul>' +
                            $.each(errors, function(index, value) {
                                return '<li>' + index + value + '</li>'
                            }) +
                        '</ul>' +
                        '<button type="button" class="close" data-dismiss="alert" aria-label="Close">' +
                            '<span aria-hidden="true">' + '&times' + '</span>' +
                        '</button>' +
                    '</div>'
                );
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
        '<div class="comment" id="comment-' + data['comment_id'] + '">' +
            '<p>' + data['comment_body'] + '</p>' +
          '<p class="small">' + data['user_email'] + '</p>' +
        '</div>'
    );
}