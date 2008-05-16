// Extend document object for cookies
/*--------------------------------------------------------------------------*/
// version 0.1.3
// requires prototype 1.6.0.1
Object.extend(document, {
  setCookie: function(name, value, expires) {
  	value = value || ''
    var expire = expires == null ? "" : ";expires = " + expires.toGMTString();
    document.cookie = name + "=" + escape(value) + "; path=/" + expire;
    if (this.cookieCache) {this.cookieCache[name] = value;}
  },
  getCookie: function(name) {
    if (document.cookie == "") {return null;}
    if (!this.cookieCache) {
      this.cookieCache = this._splitValues(document.cookie, ';', true);
    }
    return this.cookieCache[name] || null;
  },
  delCookie: function(name) {
    document.cookie = name + "=; expires=Thu, 01-Jan-70 00:00:01 GMT" + "; path=/";
    if (this.cookieCache) delete this.cookieCache[name];
  },

  setCrumb: function(cookie_name, name, value) {
    var cookie = this.getCookie(cookie_name);

    var crumbs = this._splitValues(cookie, '|');
    crumbs[name] = value || '';
    this._setCrumbValues(cookie_name, crumbs);
  },
  getCrumb: function(cookie_name, name) {
    var cookie = this.getCookie(cookie_name);
    if (!cookie == null) {return null;}

    var crumbs = this._splitValues(cookie, '|');
    return crumbs[name] || null;
  },
  delCrumb: function(cookie_name, name) {
    var cookie = this.getCookie(cookie_name);
    var crumbs = this._splitValues(cookie, '|');

    delete crumbs[name];
    this._setCrumbValues(cookie_name, crumbs);
  },

  _setCrumbValues: function(cookie_name, crumbs) {
    var values = [];
    for (var i in crumbs) {
      var value = crumbs[i] + ''; // to_s
      values.push(i+"="+value.replace('=', '^^'));
    }
    this.setCookie(cookie_name, values.join('|'));
  },

  _splitValues: function(string, delim, escaped) {
    if (string == null || string == "") {return {}; }
    var pairs = string.split(delim);
    var values = {};
    for (var i = 0, l = pairs.length; i < l; i++) {
      var keyval = pairs[i].split('=', 2);
      var key = keyval[0] ? keyval[0].strip() : null; 
      var val = keyval[1] ? keyval[1].strip() : null;
      if (key) {
      	var value = (escaped ? unescape(val) : val.replace('^^', '='));
      	if (value && value != 'null') { values[key] = value; }
      }
    }
    return values;
  }
});
