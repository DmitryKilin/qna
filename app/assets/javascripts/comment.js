$(document).on('turbolinks:load', function () {
        $('form.new-comment').on('ajax:success', function (e) {
            var xhr = e.detail[0];
            var $commentsDiv = $('.' + xhr['commented_resource'] + ' .comments .comments-list');

            $commentsDiv.append(
                '<div class="comment" id="comment-' + xhr['comment_id'] + '">' +
                    '<p>' + xhr['comment_body'] + '</p>' +
                    '<p class="small">' + xhr['user_email'] + '</p>' +
                '</div>'
                );

            console.log(e)


            // var resourceName = xhr['commentable_type'].toLowerCase();
            // var resourceId = xhr['commentable_id'];
            // var resourceContent = xhr['body'];

            // $('.' + resourceName + '-' + resourceId + ' .comment-block .comments').append('<div class="comment"><p>' + resourceContent + '</p></div>');
        })
    }
);