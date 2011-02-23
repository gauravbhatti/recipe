// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function showSubSourceTypes(type){
	$$('.sub_source_types').each(function(e){e.hide()});
	$(type).show();
}
