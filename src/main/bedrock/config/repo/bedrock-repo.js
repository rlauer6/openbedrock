function applyLocalUrl() {
    const baseUrl = $('#local-url').val().replace(/\/+$/, ''); // strip trailing slash

    $('.local-link').each(function () {
        const href = $(this).attr('href');
        const path = href.replace(/^https?:\/\/[^/]+/, '');
        $(this).attr('href', baseUrl + path);
    });

    localStorage.setItem('localBaseUrl', baseUrl);
}

$(function() {
    $('.collapsable').hide();
    
    $('h2').on('click', function() {
        $(this).next().toggle();
        const $icon= $(this).find('.collapse-section-icon');
        const current = $icon.text().trim();
        console.log(current);
        $icon.html(current === '▼' ? '▲' : '▼');
    });
    
    $('.copy-icon').click(function () {
        const $icon = $(this);
        const targetSelector = $icon.data('target');
        const $wrapper = $icon.closest('.pre-wrapper');
        const $msg = $wrapper.find('.copy-message');
        const text = $(targetSelector).text();
        
        navigator.clipboard.writeText(text).then(() => {
            $msg.stop(true, true).fadeIn(100).delay(5000).fadeOut(400);
        }).catch(err => {
            console.error('Copy failed:', err);
        });
    });


 // You can let the user set this via a form and store it

    const userBaseUrl = localStorage.getItem('docBaseUrl') || 'http://localhost:8080';
    $('#doc-base-url').val(userBaseUrl);

    // Save button handler
    $('#save-doc-base-url').on('click', function () {
        const newUrl = $('#doc-base-url').val().trim();
        if (newUrl) {
            localStorage.setItem('docBaseUrl', newUrl);
            $('#url-save-status').text('Saved!').fadeIn().delay(1500).fadeOut();
        }
    });

    $('a.doc-link').on('click', function (e) {
        e.preventDefault();

        const docUrl = $(this).attr('href');
        const userBaseUrl = localStorage.getItem('docBaseUrl') || 'http://localhost:8080';
        
        $.get(docUrl)
            .done(function (data) {
                // Replace hardcoded localhost URLs
                const rewritten = data.replace(/http:\/\/localhost:8080/g, userBaseUrl);
                
                // Open new tab with rewritten HTML
                const newWin = window.open('', '_blank');
                newWin.document.open();
                newWin.document.write(rewritten);
                newWin.document.close();
            })
            .fail(function (jqXHR, textStatus, errorThrown) {
                alert('Failed to load documentation: ' + textStatus);
                console.error(errorThrown);
            });
    });
    
});

 
