// ------------------------------------------------
function get_action_url() {
// ------------------------------------------------
    var url = $('form').attr('action');

    if ( ! url ) {
        url = document.location.pathname;
    }

    return url;
}

// ------------------------------------------------
function _invoke_ith_action() {
// ------------------------------------------------
    var formData = $('form').serializeArray();

    $.ajax({
        url: get_action_url(),
        method: "POST",
        data: formData,
        success: function (data) {
            console.log(data);
            $('#ith-message').text('Successfully saved...id: ' + data.id);

            $('#ith-message').show();

            $('form').trigger('reset');

            setTimeout(function() {
                $('#ith-message').hide();
            }, 3000);

        },
        error: function (e) {
        }
    });

    return false;
}
 
// ------------------------------------------------
$(function() {
// ------------------------------------------------    
    $('button').on('click', function(e) {
        e.preventDefault();

        if ( $(this).val() == 'new' ) {
            $('form').trigger('reset');
            $('#id').val(0);
            return false;
        }
        
        var action = $(this).val();

        $('input[name="action"]').val(action);

        alert($('input[name="action"]').val());

        _invoke_ith_action();

        return false;
    });
});
