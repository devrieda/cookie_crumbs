# CookieCrumbs
    by Derek DeVries
    http://www.derekdevries.com

## DESCRIPTION:

CookieCrumbs is a Rails plugin that adds the ability to store more than 
one value for a single cookie. This is helpful in applications that 
need to store more than the maximum 20 allowed cookies.

Note: This is an old plugin, and likely will not work anymore since it depends
on internal Rails structure.


## SYNOPSIS:

CookieCrumbs provides both Rails and Javascript code needed to set cookies so
that you can easily trade information between client and server side actions. 

### In a Rails Controllers

The plugin will add a new method to your controller classes to access the 
crumbs. 

```ruby
def index
  # setting crumbs - these all save to the same 'widget' cookie
  crumbs[:widget] = { :favorites => "open", :sources => "closed" }
  # or
  crumbs[:widget][:favorites] = "open"
  crumbs[:widget][:sources]   = "closed"

  # getting crumbs
  crumbs[:widget] # => { :favorites => "open", :sources => "closed" }
  crumbs[:widget][:favorites] # => "open"

  # deleting crumbs
  crumbs[:widget].delete :favorites
end
```

### In the Javascript

The javascript library extends the document object with various methods for
manipulating both cookies and crumbs. 

```javascript
// cookies (set/get/delete)
document.setCookie('sidebar', 'open');
document.getCookie('sidebar');
document.delCookie('sidebar');

// setting crumbs - these all save to the same 'widget' cookie
document.setCrumb('widget', 'favorites' 'open');
document.setCrumb('widget', 'sources'   'closed');

// getting crumbs
document.getCrumb('widget', 'favorites'); // => "open"

// deleting crumbs
document.delCrumb('widget', 'sources');
```

## REQUIREMENTS:

This plugin is only compatible with Rails 2.3 projects

The Prototype Library (http://prototype.conio.net) is required for the 
javascript crumb code to work. 


## INSTALL:

### The Plugin

```
$ ./script/plugin install git://github.com/devrieda/cookie_crumbs
```

If you are upgrading from a previous version, update your application
javascripts with:

```
rake cookie_crumbs:install
```

### Including the javascript file

The javascript portion of this library is not required for the rails portion
to work. It is based on the Prototype library and can be added to your
application using the usual helpers. 

```ruby
<%= javascript_include_tag 'prototype', 'cookie_crumbs %>
```

## LICENSE

Copyright (c) 2007 Derek DeVries

Released under the [MIT License](http://www.opensource.org/licenses/MIT)
