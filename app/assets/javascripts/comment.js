$(document).on('turbolinks:load', function () {
        $('form.new-comment').on('ajax:success', function (e) {
            var xhr = e.detail[0];
            var $divComments = $('.' + xhr['commented_resource'] + ' .comments .comments-list');

            $divComments.append(
                '<div class="comment" id="comment-' + xhr['comment_id'] + '">' +
                    '<p>' + xhr['comment_body'] + '</p>' +
                    '<p class="small">' + xhr['user_email'] + '</p>' +
                '</div>'
                );

        })
            .on('ajax:error', function (e) {
                var errors = e.detail[0].body;
                var $divErrors = $('.notifications');
                console.log(errors.length);

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
            })
    }
);