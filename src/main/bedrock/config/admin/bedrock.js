var containers = 'login logout session register plugins tags docs'.split(' ');

var spinner = '<div class="d-flex mt-5 justify-content-center"><div class="spinner-border" role="status"><span class="visually-hidden">Loading...</span></div></div>';

// -------------------------------------------------
function enable_tooltips() {
// -------------------------------------------------
    const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
    const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl));
}

// -------------------------------------------------
function show_spinner(container, hide) {
// -------------------------------------------------
    var containerId = `#${container}-container`;

    if ( hide ) {
        $(containerId).html('');
        $(containerId).removeClass('d-flex justify-content-center');
    }
    else {
        $(containerId).html(spinner);
        $(containerId).addClass('d-flex justify-content-center');
    }
}

// -------------------------------------------------
function show_container(container, top_button, history_button) {
// -------------------------------------------------
    containerId = `#${container}-container`;

    containers.forEach((c) => {
        $(`#${c}-container`).hide();
    });

    $('#top-button').hide();
    $('#back-button').hide();

    if ( $(containerId).length ) {
        $(containerId).show();
    }
    
    $('#top-button').off('click');
    
    if ( top_button ) {
        $('#top-button').show();
      
        $('#top-button').click(function() {
            $(containerId).scrollTop(0);
        });
    }
    
    if ( history_button && ui_history.length > 1 ) {
       $('#back-button').show();
    }
}

// -------------------------------------------------
function bedrock_error(message, alert_type) {
// -------------------------------------------------
    $('#bedrock-error-message').text(message);

    $('#bedrock-error').removeClass();

    if ( !alert_type ) {
        alert_type = 'danger';
    }

    alert_type = 'alert-' + alert_type;

    $('#bedrock-error').addClass('alert ' + alert_type + ' alert-dismissible fade show');

    $('#bedrock-error').show();
}

// -------------------------------------------------
function api_tag_list() {
// -------------------------------------------------
    show_spinner('tags');

    $.ajax({
        url: '/bedrock/tag',
        dataType: 'json',
        headers: { 'Accept': 'application/json' },
        method: 'GET',
        contentType: 'application/json'
    }).done(function (data) {

        show_spinner('tags', 1);

        console.log(data);

        var html = ul_list(data.tags, 'tag-list', '', 'ul-link-item');
        $('#tags-container').html(html);

        $('.ul-link-item').on('click', function() {
            api_tag_doc($(this).text());
        });

        show_container('tags');

        return true;
    }).fail(function($xhr, status, error) {

        console.log($xhr);
        console.log(status);
        console.log(error);

        show_spinner('tags', 1);
        
        bedrock_error(`Error fetching data [${status}]: ${error}`);
        
        return false;
    });
}

// -------------------------------------------------
function api_config() {
// -------------------------------------------------
    $.ajax({
        url: '/bedrock/config',
        dataType: 'json',
        headers: { 'Accept': 'application/json' },
        method: 'GET',
        contentType: 'application/json'
    }).done(function (data) {
        console.log(data);

        return true;
    }).fail(function($xhr, status, error) {

        console.log($xhr);
        console.log(status);
        console.log(error);
        
        bedrock_error(`Error fetching data [${status}]: ${error}`);
        
        return false;
    });
}
// -------------------------------------------------
function api_session() {
// -------------------------------------------------
    $.ajax({
        url: '/bedrock/session',
        dataType: 'json',
        headers: { 'Accept': 'application/json' },
        method: 'GET',
        contentType: 'application/json'
    }).done(function (data) {
        console.log(data);

        return true;
    }).fail(function($xhr, status, error) {

        console.log($xhr);
        console.log(status);
        console.log(error);
        
        bedrock_error(`Error fetching data [${status}]: ${error}`);
        
        return false;
    });
}

// -------------------------------------------------
function api_tag_doc(tag) {
// -------------------------------------------------
    show_spinner('tags');

    $.ajax({
        url: '/bedrock/tag/' + tag,
        dataType: 'json',
        headers: { 'Accept': 'application/json' },
        method: 'GET',
        contentType: 'application/json'
    }).done(function (data) {
        console.log(data);
        show_spinner('tags', 1);

        var html = data.html
        html = '<div class="bedrock-pod"><span id="_podtop_"></span>' + html + '</div>';

        $('#tags-container').html(html);

        show_container('tags');

        return true;
    }).fail(function($xhr, status, error) {

        console.log($xhr);
        console.log(status);
        console.log(error);
        
        show_spinner('tags', 1);

        bedrock_error(`Error fetching data [${status}]: ${error}`);
        
        return false;
    });
}

// -------------------------------------------------
function api_generic_doc(contentName, func) {
// -------------------------------------------------
    show_spinner('docs');

    $.ajax({
        url: '/bedrock/docs/' + contentName,
        dataType: 'json',
        headers: { 'Accept': 'application/json' },
        method: 'GET',
        contentType: 'application/json'
    }).done(function (data) {
        var html = data.html
        //html = '<span id="_podtop_"></span>' + html;
        show_spinner('docs', 1);

        func(html, contentName);

        return true;
    }).fail(function($xhr, status, error) {

        console.log($xhr);
        console.log(status);
        console.log(error);
        
        show_spinner('docs', 1);

        bedrock_error(`Error fetching data [${status}]: ${error}`);
        
        return false;
    });
}

// -------------------------------------------------
function api_module_doc(plugin_type, plugin) {
// -------------------------------------------------
    show_spinner('tags');

    var plugin_types = { "Application Plugins" : "/bedrock/plugins/Startup",
                         "Filters" : "/bedrock/plugins/Filter",
                         "Plugins" : "/bedrock/plugins"
                       };
    var url;

    if  (plugin) {
        plugin = plugin == 'Filter' ? '' : '/' + plugin;
        url = plugin_types[plugin_type] + plugin;
    }
    else {
        url = `/bedrock/pod/${plugin_type}`;
        plugin = plugin_type;
    }

    $.ajax({
        url: url,
        dataType: 'json',
        headers: { 'Accept': 'application/json' },
        method: 'GET',
        contentType: 'application/json'
    }).done(function (data) {
        console.log(data);

        show_spinner('tags', 1);

        if ( data.url ) {
            window.open(data.url, '_blank');
            return;
        }
        
        var html = data.html;
        
        if ( html ) {
            html = `<div class="bedrock-pod"><span id="_podtop_">${html}</span></div>`;
        }
        else {
            bedrock_error(`Nothing found for "${plugin}" warning`);
            return;
        }

        $('#tags-container').html(html);

        $('.pod-link').on('click', function() {
            var bedrock_data = $(this).attr('bedrock-data');
            var module = bedrock_data.split('?');
            
            api_module_doc(module[0]);
        });

        show_container('tags');

        return true;
    }).fail(function($xhr, status, error) {

        show_spinner('tags', 1);

        console.log($xhr);
        console.log(status);
        console.log(error);
        
        bedrock_error(`Error fetching data [${status}]: ${error}`);

        return false;
    });
}

// -------------------------------------------------
function ul_list(list, id, uri_root, css_class) {
// -------------------------------------------------
    css_class = css_class ? ` class="${css_class}"` : '';

    uri_root = uri_root ? uri_root + '/' : '';

    var ul = '';

    list.forEach((item) => {
        if ( uri_root) {
            ul += `<li><a href="${uri_root}${item}">${item}</a></li>\n`;
        }
        else {
            ul += `<li${css_class}>${item}</li>\n`;
        }
    });

    return `<ul id="${id}">\n${ul}</ul>\n`;
}

// -------------------------------------------------
function api_plugins() {
// -------------------------------------------------
    show_spinner('tags');

    $.ajax({
        url: '/bedrock/plugins',
        dataType: 'json',
        headers: { 'Accept': 'application/json' },
        method: 'GET',
        contentType: 'application/json'
    }).done(function (data) {

        console.log(data);

        show_spinner('tags', 1);

        var plugins = data.plugins;
        var plugin_map = data.plugin_map;
        var plugin_links = data.links;
        var plugin_names = data.names;

        var sections = Object.keys(plugins);

        var section_ids = [];

        for (const s in plugin_map ) {
            var id = `#${plugin_map[s]} .accordion-body`;

            var items = plugins[s];
            var links = plugin_links[s];
            var names = plugin_names[s];

            var ul = '';

            items.forEach((item) => {
                ul += `<li class="ul-link-item" bedrock-data="${s}">${names[item]}</li>\n`;
            });

            var html = `<h2>${s}</h2>\n`;
            html = `<ul id="${plugin_map[s]}_list">\n${ul}</ul>`;

            $(id).html(html);
        }

        $('.ul-link-item').on('click', function() {
            api_module_doc($(this).attr('bedrock-data'), $(this).text());
        });

        show_container('plugins');
        
        return true;
    }).fail(function($xhr, status, error) {

        console.log($xhr);
        console.log(status);
        console.log(error);

        show_spinner('tags', 1);

        bedrock_error(`Error fetching data [${status}]: ${error}`);
        
        return false;
    });

}

// -------------------------------------------------
function api_modules(module_type) {
// -------------------------------------------------
    show_spinner('tags');

    $.ajax({
        url: '/bedrock/' + module_type,
        dataType: 'json',
        headers: { 'Accept': 'application/json' },
        method: 'GET',
        contentType: 'application/json'
    }).done(function (data) {

        show_spinner('tags', 1);

        console.log(data);

        var modules = data.modules;
        
        var ul = '';
        modules.forEach((module) => {
            var link = module.replaceAll('::', '/');
            var href = '#module-' + module_type;
            ul += `<li class="ul-link-item"><a data-bedrock="${link}" href="${href}">${module}</a></li>\n`;
        });

        var html = `<ul>\n${ul}</ul>`;

        $('#tags-container').html(html);

        show_container('tags');

//        $('.ul-link-item').on('click', function() {
//            api_module_doc($(this).attr('bedrock-data'));
//        });

        
        return true;
    }).fail(function($xhr, status, error) {

        console.log($xhr);
        console.log(status);
        console.log(error);
        
        show_spinner('tags', 1);

        bedrock_error(`Error fetching data [${status}]: ${error}`);
        
        return false;
    });
}

// -------------------------------------------------
function enable_internal_links (container) {
// -------------------------------------------------
    $('.bedrock-pod').off('click');

    fix_encoded_links();

    $('.bedrock-pod a').on('click', function(e) {
        e.preventDefault();
        
        // DBD::SQLite anchors contain ':'
        var ahref = $(this).attr('href'); // anchors appear to now be URL encoded
        if (ahref.substring(0,4) == 'http' ) {
          document.location = ahref;
          return true;
        }

        ahref = decodeURIComponent(ahref);
        ahref = ahref.replaceAll(':', '\\:');

        $(container).scrollTop(0);
        var containerOffset=$('#abs-top').offset().top;
        var topOffset = $(ahref).offset().top;
	$(container).scrollTop(topOffset - containerOffset);
    });
}

// -------------------------------------------------
function set_container_size () {
// -------------------------------------------------
    var container_top = $('#abs-top').offset().top;

    var container_height = $('footer').offset().top - container_top;

    $('#tags-container').css('height', container_height);
    $('#docs-container').css('height', container_height);
}


// ------------------------------------------------------------------------
function show_tag_doc() {
// ------------------------------------------------------------------------
    $('#docs-container a').on('click', function(e) { 
        var ahref = $(this).attr('href'); 

        if (ahref.substring(0, 5, ahref) == '#tag-' ) { 
            var tag_name = ahref.replace('#tag-', '');
            api_tag_doc(tag_name);
            return false;
        } 

        return true;
    });
}

// ------------------------------------------------------------------------
function loadContent(contentName) {
// ------------------------------------------------------------------------
    if ( contentName == 'tags' ) {
        api_tag_list();
    } else if ( contentName == 'plugins' ) {
        api_plugins();
    } else if ( contentName == 'bedrock-modules' ) {
        api_modules('bedrock-internal');
    } else if ( contentName == 'perl-modules' ) {
        api_modules('system');
    } else if ( contentName == 'login' ) {
        show_container('login');
    } else if ( contentName == 'register' ) {
        show_container('register')
    } else {
        api_generic_doc(contentName, function(html, id) {
            id = '#docs-container';
            $(id).html(html);
            $(id).css('display', 'inline-block');

            var containerSize = $('footer').offset().top - $(id).offset().top;
            $(id).height(containerSize);
	    $(id).css('overflow', 'scroll');

            $('#docs-container').scrollTop(0);

            if ( contentName == 'examples' || contentName == 'tutorials' ) {
                show_tag_doc();
            }

        });
    }
}

// ------------------------------------------------------------------------
function loadView(section, data) {
// ------------------------------------------------------------------------
    const contentDiv = document.getElementById('docs-container');

    var hrefArray = $('.list-group a').map(function () {
        return $(this).attr('href');
    }).get();

    var isLeftMenu = hrefArray.find(element => element === '#' + section);

    var dropDown = $('.dropdown-menu a').map(function () {
        return $(this).attr('href');
    }).get();

    var navLinks = $('.nav-link').map(function() {
        return $(this).attr('href');
    }).get();
    
    hrefArray = hrefArray.concat(dropDown, navLinks);
    
    hrefArray = hrefArray.filter((link) => link != '#');

    var contentName = hrefArray.find(element => element === '#' + section);

    if ( contentName ) {
        contentName = contentName.replace('#','');
        contentDiv.innerHtml = loadContent(contentName);
    }
    else if ( data ) {
        var module_type = section.replace('module-', '');
        api_module_doc(data);
    }
}

// ------------------------------------------------------------------------
// Function to handle navigation
// ------------------------------------------------------------------------
function navigateTo(hash, data) {
    // Extract section name from the hash (e.g., #home -> home)
    const section = hash.replace('#', '');

    // Dynamically load content for the section
    loadView(section, data);
    
    // Update the browser's history stack
    history.pushState({ section: section }, '', hash);
}


// -------------------------------------------------
$(function () {
// -------------------------------------------------
    set_container_size();

    $(window).resize(function() {
        set_container_size();
    });

    // show_container('left-menu');
    
    // prevent alert from being removed from DOM
    $('#bedrock-error').on('close.bs.alert', function() {
        $('#bedrock-error').hide();
        return false;
    });

    $('#module-search').on('click', function(e, back) {
        e.preventDefault();        
        api_module_doc( $('#module-name').val());
    });

    $('#bedrock-logo').on('click', function(e, back) {
        history.pushState({ section: section }, '', location.hash);
        navigateTo('welcome');
    });

    $("#username").attr('tabindex', 100);
    $("#password").attr('tabindex', 101);

//    containers.forEach((container) => {
//        $('#' + container + '-link').on('click', function () {
//            show_container(container);
//       });
//    });

    var login_containers = [ 'login', 'logout' ];

    login_containers.forEach((action) => {
        var id = '#' + action + '-button';

        if ( $(id).length ) {
            $(id).on('click', function () {
                
                $('#login-action').val(action);
                
                if ( action == 'login' ) {
                    var username=$('#username').val().trim();
                    var password=$('#password').val().trim();
                    
                    if ( !username || !password ) {
                        bedrock_error('please enter username and password');
                        return false;
                    }
                }
                
                $('#login-form').submit();
            });
        }
    });

    $('#register-button').on('click', function(e) {
        e.preventDefault();

        var username=$('#register-username').val().trim();
        var password=$('#register-password').val().trim();
        var email=$('#email').val().trim();

        if ( !username || !password || !email ) {
            bedrock_error('username, password amd email are required');
            return false;
        }

        var first_name=$('#first_name').val().trim();
        var last_name=$('#last_name').val().trim();

        $('#register-form').submit();
    });

    enable_tooltips();

    // Handle clicks on internal links
    document.addEventListener('click', (event) => {
        const target = event.target;

        if (target.tagName === 'A' && target.dataset.bedrock !== undefined) {
            event.preventDefault(); // Prevent default behavior
            const hash = target.getAttribute('href'); // Get the hash

            navigateTo(hash, target.dataset.bedrock); // Navigate using the custom handler
        }
        else {
            console.log('not sure where to go from here...');
        }
    });

    // Handle back/forward navigation
    window.addEventListener('popstate', (event) => {
        const hash = location.hash; // Get the current hash
        const section = hash ? hash.replace('#', '') : 'welcome';
        loadView(section); // Reload the view
    });

    // Handle hash changes (when users manually modify the URL or use a bookmark)
    window.addEventListener('hashchange', () => {
        const hash = location.hash; // Get the current hash
        const section = hash.replace('#', '');
        loadView(section); // Reload the view based on the hash
    });

    // Handle direct visits and bookmarked links
    window.addEventListener('DOMContentLoaded', () => {
        // Get the current hash (or default to #home)
        const hash = location.hash || '#welcome';
        const section = hash.replace('#', '');
        loadView(section); // Load the view dynamically
    });

    // just update the color of the menu selected
    $('.list-group-item').on('click', function(e, back) {
        var activeLink = $('.list-group-item.active');
        $(activeLink).removeClass('active');

        $(this).addClass('active');
    });

});
