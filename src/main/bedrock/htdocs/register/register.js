// register.js

// ---------------------------------------------------------------------
function alertMessage(alert_type, message, timeout) {
// ---------------------------------------------------------------------
    var alert_message_container = document.getElementById('alert-message-container');
    var alert_message = document.getElementById('alert-message');

    alert_message_container.classList.remove('alert-danger', 'alert-success','alert-info');
    alert_message_container.classList.add(alert_type);

    alert_message.innerHTML = message;

    alert_message_container.classList.remove('d-none');
    alert_message_container.classList.add('show', 10);

    if ( timeout ) {
        // Auto-hide it
        setTimeout(() => {
            alert_message_container.classList.remove('show'); // triggers fade out
            setTimeout(() => alert_message_container.classList.add('d-none'), 300); // hide after fade
        }, 5000);
    }
}

// ---------------------------------------------------------------------
document.addEventListener('DOMContentLoaded', function () {
// ---------------------------------------------------------------------
    // reset password
    if ( action == 'reset-password' ) {
        if ( password_changed ) {
            alertMessage('alert-success', 'Your password has been successfully changed.', 1);
            document.getElementById('login-form-container').classList.remove('d-none');
        }
        else if (! session["username"] )  {
            alertMessage('alert-danger', 'Your session token has expired. Use the Forgot Password link to create a new temporary session.');
        }
        else if (password_changed == -1) {
            alertMessage('alert-danger', 'Your passwords did not match. Try again.');
        }
        // forgot-password
        else {
            document.getElementById('reset-password-container').classList.remove('d-none');
        }
    }

    if ( registered ) {
      alertMessage('alert-success', `You have successfully registered as ${username}.`, 1);
    }

    if ( login_error ) {
        alertMessage('alert-danger', login_error);
    }

    if (session["username"] && ! token) {
        document.getElementById('session-message').innerHTML = JSON.stringify(session, null, 2);
        document.getElementById('session-container').classList.remove('d-none');
    }
    else if ( action != 'reset-password' ) {
        document.getElementById('login-form-container').classList.remove('d-none');
    }

    // forgot-password submit
    if ( email_sent ) {
        var msg = `An email has been sent to ${user["email"]}>. Click on the link in the email to reset your password.`;
        alertMessage('alert-success', msg, 1);
    }
    else if ( typeof user !== 'undefined' ) {
        if ( ! user["email"] ) {
            alertMessage(`alert-danger', 'No email for this registered user (${username}).`);
        }
    }

    if (typeof session !== 'undefined' && session["username"]) {
        var ptag = document.querySelector('#login-message p');
        message = `You are logged in as <span>${session["username"]}</span>(<span>${session["email"]}</span>)`
        document.getElementById('login-message').classList.remove('d-none');
    }

    // forgot password
    var forgot_link_id = document.getElementById('forgot_link');

    if ( forgot_link_id ) {
        document.getElementById('forgot_link').addEventListener('click', function (event) {
            event.preventDefault();

            document.getElementById('forgot_password').value = '1';

            var username = document.getElementById('login_form').elements['username'].value.trim();
            
            if ( ! username ) {
	        var errorMessage = document.getElementById('alert-message');
                var errorBox = document.getElementById('alert-message-container');
                alertMessage('alert-danger', 'Enter a username-then click the Forgot Password link');
                
                // Show it
                errorBox.classList.remove('d-none');
                setTimeout(() => errorBox.classList.add('show'), 10); // allow fade to kick in
                
                // Auto-hide it
                setTimeout(() => {
                    errorBox.classList.remove('show'); // triggers fade out
                    setTimeout(() => errorBox.classList.add('d-none'), 300); // hide after fade
                }, 3500);
            }
            else {
                document.getElementById('login_form').submit();
            }
        });
    }

});
