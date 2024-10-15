var containers = 'login logout session register plugins tags'.split(' ');

var spinner = '<div class="d-flex mt-5 justify-content-center"><div class="spinner-border" role="status"><span class="visually-hidden">Loading...</span></div></div>';

// -------------------------------------------------
function enable_tooltips() {
// -------------------------------------------------
  const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
  const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl));
}

// -------------------------------------------------
function show_spinner(hide) {
// -------------------------------------------------
  if ( hide ) {
    $('#tags-container').html('');
  }
  else {
    $('#tags-container').html(spinner);
  }

  show_container('tags');
}

// -------------------------------------------------
function show_container(container) {
// -------------------------------------------------
  containers.forEach((c) => {
    $('#' + c + '-container').hide();
  });

  $('#top-button').hide();

  if ( $('#' + container +'-container').length ) {
    $('#' + container +'-container').show();
  }

  if ( container == 'tags' ) {
    $('#top-button').show();
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
  show_spinner();

  $.ajax({
    url: '/bedrock/tag',
    dataType: 'json',
    headers: { 'Accept': 'application/json' },
    method: 'GET',
    contentType: 'application/json'
  }).done(function (data) {
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

    show_spinner(1);
    
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
  show_spinner();

  $.ajax({
    url: '/bedrock/tag/' + tag,
    dataType: 'json',
    headers: { 'Accept': 'application/json' },
    method: 'GET',
    contentType: 'application/json'
  }).done(function (data) {
    console.log(data);

    var html = data.html
    html = '<div class="bedrock-pod"><span id="_podtop_"></span>' + html + '</div>';

    $('#tags-container').html(html);

    show_container('tags');

    return true;
  }).fail(function($xhr, status, error) {

    console.log($xhr);
    console.log(status);
    console.log(error);
    
show_spinner(1);

    bedrock_error(`Error fetching data [${status}]: ${error}`);
 
    return false;
  });
}

// -------------------------------------------------
function api_plugin_doc(plugin_type, plugin) {
// -------------------------------------------------
  show_spinner();

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

    if ( data.url ) {
      window.open(data.url, '_blank');
      return;
    }

    var html = data.html;

    if ( html ) {
      html = `<div class="bedrock-pod"><span id="_podtop_">${html}</div>`;
    }
    else {
      show_spinner(1);
      bedrock_error(`Nothing found for "${plugin}" warning`);
      return;
    }

    $('#tags-container').html(html);

    if ( data.source && data.source == 'metacpan' ) {
      $('.bedrock-pod h1').on('click', function() {
        // location = '#_podtop_';
      });
    }
    else {
      $('#top-button').on('click', function() {
        $('#tags-container').scrollTop('#tags-container').position().top;
      });

      $('.bedrock-pod a').on('click', function(e) {
        e.preventDefault();
        var ahref = $(this).attr('href');
        var topOffset = $(ahref).offset().top;
        var offset=$('#tags-container').position().top;
        $('#tags-container').scrollTop(topOffset - offset);
      });

      $('.pod-link').on('click', function() {
        var bedrock_data = $(this).attr('bedrock-data');
        var module = bedrock_data.split('?');
        
        api_plugin_doc(module[0]);
      });
    }

    show_container('tags');

    //location = '#_podtop_';

    return true;
  }).fail(function($xhr, status, error) {

    show_spinner(1);

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
  show_spinner();

  $.ajax({
    url: '/bedrock/plugins',
    dataType: 'json',
    headers: { 'Accept': 'application/json' },
    method: 'GET',
    contentType: 'application/json'
  }).done(function (data) {

    console.log(data);

    var plugins = data.plugins;
    var plugin_map = data.plugin_map;
    var plugin_links = data.links;
    var plugin_names = data.names;

    var sections = Object.keys(plugins);

    var section_ids = [];

    var ul = '';

    for (const s in plugin_map ) {
      var id = `#${plugin_map[s]} .accordion-body`;

      var items = plugins[s];
      var links = plugin_links[s];
      var names = plugin_names[s];

      items.forEach((item) => {
        ul += `<li class="ul-link-item" bedrock-data="${s}">${names[item]}</li>\n`;
      });

      var html = `<h2>${s}</h2>\n`;
      html = `<ul id="${plugin_map[s]}_list">\n${ul}</ul>`;

      $(id).html(html);
    }

    $('.ul-link-item').on('click', function() {
      api_plugin_doc($(this).attr('bedrock-data'), $(this).text());
    });

    show_container('plugins');
    
    return true;
  }).fail(function($xhr, status, error) {

    console.log($xhr);
    console.log(status);
    console.log(error);

    show_spinner(1);

    bedrock_error(`Error fetching data [${status}]: ${error}`);
    
    return false;
  });

}

// -------------------------------------------------
function api_modules(module_type) {
// -------------------------------------------------
    show_spinner();

  $.ajax({
    url: '/bedrock/' + module_type,
    dataType: 'json',
    headers: { 'Accept': 'application/json' },
    method: 'GET',
    contentType: 'application/json'
  }).done(function (data) {

    console.log(data);

    var modules = data.modules;
    
    var ul = '';
      modules.forEach((module) => {
        var link = module.replaceAll('::', '/');
        ul += `<li class="ul-link-item" bedrock-data="${link}">${module}</li>\n`;
      });

    var html = `<ul>\n${ul}</ul>`;

    $('#tags-container').html(html);
    
    $('.ul-link-item').on('click', function() {
      api_plugin_doc($(this).attr('bedrock-data'));
    });

    show_container('tags');
    
    return true;
  }).fail(function($xhr, status, error) {

    console.log($xhr);
    console.log(status);
    console.log(error);
    
    show_spinner(1);

    bedrock_error(`Error fetching data [${status}]: ${error}`);
    
    return false;
  });
}

// -------------------------------------------------
$(function () {
// -------------------------------------------------
  var container_top = document.getElementById('tags-container').offsetTop;
  $('#tags-container').css('height', document.innerHeight - container_top);

  $('#module-search').on('click', function(e) {
    e.preventDefault();
    api_plugin_doc( $('#module-name').val());
  });

  $('.dropdown-menu li a').on('click', function (e) { 
    e.preventDefault();
    
    var active_item = $(this).text();

    if ( active_item  == 'Plugins' ) {
      api_plugins();
    }
    else if ( active_item == 'Tags' ) {
      api_tag_list();
    }
    else if ( active_item == 'Bedrock Modules') {
      api_modules('bedrock-internal');
    }
    else if ( active_item == 'Installed Perl Modules') {
      api_modules('system');
    }
  });

  $("#username").attr('tabindex', 100);
  $("#password").attr('tabindex', 101);

  containers.forEach((container) => {
    $('#' + container + '-link').on('click', function () {
      show_container(container);
    });
  });

  var login_containers = [ 'login', 'logout' ];

  login_containers.forEach((action) => {
    var id = '#' + action + '-button';

    if ( $(id).length ) {
      $(id).on('click', function () {
        
        $('#login-saction').val(action);
      
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
});


