(function(){navigator.sayswho=function(){var e,t,n;return n=navigator.userAgent,t=void 0,e=n.match(/(opera|chrome|safari|firefox|msie|trident(?=\/))\/?\s*(\d+)/i)||[],/trident/i.test(e[1])?(t=/\brv[ :]+(\d+)/g.exec(n)||[],"IE "+(t[1]||"")):"Chrome"===e[1]&&(t=n.match(/\bOPR\/(\d+)/),null!==t)?"Opera "+t[1]:(e=e[2]?[e[1],e[2]]:[navigator.appName,navigator.appVersion,"-?"],null!==(t=n.match(/version\/(\d+)/i))&&e.splice(1,1,t[1]),e)}(),$(function(){var e,t,n;return n=navigator.sayswho,e=n[0],t=n[1],n})}).call(this);