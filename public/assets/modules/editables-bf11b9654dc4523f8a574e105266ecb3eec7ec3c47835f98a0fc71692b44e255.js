(function(){var t;t=function(){var t,e;return e=function(e){var n;return e.append($("<i class='fa fa-circle-o-notch fa-spin'></i>")),n=$("#editable_form"),n.attr("action",e.data("editable-url")),n.children("input[type=hidden]").attr("name",e.data("editable-object")+"["+e.data("editable-field")+"]"),n.children("input[type=hidden]").val(e.text()),t(this,!1),$.rails.handleRemote(n)},t=function(t,e){var n;return n=$(t).parents("[data-editable-mark-state]"),e?n.attr("id",n.attr("id")+":::editing"):n.each(function(t,e){return console.log(e),$(e).attr("id",$(e).attr("id").split(":::")[0])})},$(document).on("click","[data-editable-url]",function(){if("true"!==$(this).attr("contenteditable"))return $(this).attr("contenteditable","true"),$(this).data("editable-original",$(this).text()),t(this,!0),$(this).selectText()}),$(document).on("focusout","[data-editable-url]",function(){return $(this).attr("contenteditable","false"),$(this).text()!==$(this).data("editable-original")?confirm("Do you want to save your change? ")?e($(this)):($(this).text($(this).data("editable-original")),t(this,!1)):t(this,!1)}),$(document).on("keypress","[data-editable-url]",function(n){var i;return i=n.keyCode?n.keyCode:n.which,13===i&&(t(this,!1),$(this).attr("contenteditable","false"),e($(this))),!0})},$(document).ready(t),$(document).on("turbolinks:load",t)}).call(this);