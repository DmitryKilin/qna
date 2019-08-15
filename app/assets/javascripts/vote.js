$(document).on('turbolinks:load', function () {
    $('.poll').on('ajax:success', '.vote', function (e) {
        var xhr = e.detail[0];
        var votableType = xhr['votableType'];
        var votableId = xhr['votableId'];
        var pollResult = xhr['pollResult'];

        var elID = '#amount' + '-' + votableType + '-' + votableId;
        $( elID ).html(pollResult);
    });
});