(function(){$(function(){return $.getJSON("/ads-manifest",function(t){return $("[data-ads]").each(function(n,a){var r,o,e;return e=$(a).data("ads"),r=t[e],r.length>0?(o=r[Math.floor(Math.random()*r.length)],a.src=o,$(a).show()):void 0})})})}).call(this);