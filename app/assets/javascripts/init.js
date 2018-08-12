/* code source: https://www.driftingruby.com/episodes/page-specific-javascript-in-ruby-on-rails */

var Page, bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
Page = (function() {
    function Page() {
        this.action = bind(this.action, this);
        this.controller = bind(this.controller, this);
    }
    Page.prototype.controller = function() {
        return $('meta[name=page_specific]').attr('controller');
    };
    Page.prototype.action = function() {
        return $('meta[name=page_specific]').attr('action');
    };
    return Page;
})();

this.page = new Page;