module ActionController
  # CookieCrumbs are a collection of key/value pairs saved to a single cookie. They are read and written through ActionController#crumbs. 
  # This method retrieves a single cookie, and returns it as a hash based on the subvalues separated by pipe (|)
  # The sub-hash values of the crumbs can be read and written using normal hash conventions. 
  # Examples for writing: 
  # 
  #   crumbs[:user] = { :name => "derek", :age => "26" } # => Will set single cookie that stores both name/age
  #   crumbs[:user][:name] = "mike"                      # => Will update only the name part of the user cookie
  # 
  # Examples for reading:
  #
  #   crumbs[:user]        # => { :name => "derek", :age => "26" }
  #   crumbs[:user][:name] # => "derek"
  # 
  # Examples for deleting: 
  # 
  #   crumbs[:user].delete :name  # => delete only the name part of the user cookie
  # 
  module CookieCrumbs
    def self.included(base)
      base.helper_method :crumbs
    end

    protected 
      # Returns the cookie crumb container
      def crumbs
        @crumb_jar ||= CrumbJar.new(self)
      end
  end

  class CrumbJar < Hash #:nodoc:
    def initialize(controller)
      @controller = controller
      @cookies, @crumbs = controller.request.cookies, {}
      super
      update(@cookies)
    end

    # Returns the value of the crumb collection (cookie) by +name+ -- or empty hash if no such collection exists. 
    def [](name)
      unless @crumbs[name.to_s]
        if @cookies[name.to_s] && @cookies[name.to_s].respond_to?(:value)
          value = @cookies[name.to_s].value.first
        end
        @crumbs[name.to_s] = Crumb.new(name.to_s, self, value || "")
      end
      @crumbs[name.to_s]
    end

    # Set a hash of key/values to be saved as a single cookie
    def []=(name, value)
      if value.is_a?(Hash)
        value = value.collect {|key, val| "#{key}=#{val.gsub('=', '^^')}" }.join('|')
      end
      set_cookie("name" => name.to_s, "value" => value)
    end

    private
      def set_cookie(options) #:nodoc:
        options["path"] = "/" unless options["path"]
        cookie = CGI::Cookie.new(options)
        @controller.logger.info "Cookie set: #{cookie}" unless @controller.logger.nil?

        pos = false
        @controller.response.headers["cookie"].each_with_index do |c, i|
          pos = i if c.name == options["name"]
        end

        @controller.response.headers["cookie"][pos] = cookie if pos
        @controller.response.headers["cookie"] << cookie unless pos
      end
  end

  class Crumb < Hash #:nodoc:
    def initialize(name, cookie, crumbs)
      @name, @cookie, @crumbs = name, cookie, {}

      crumbs.split('|').each do |c| 
        k, v = c.split('=')
        @crumbs[k] = (v ? v.gsub('^^', '=') : v) # unescape equals
      end

      super(@crumbs)
      update(@crumbs)
    end

    # Returns the value of the crumb by +name+ -- or nil if no such name exists. 
    def [](name)
      @crumbs[name.to_s]
    end

    # Set a crumb value, which is a value of a sub-part of a cookie.
    def []=(name, value)
      @crumbs[name.to_s] = value.to_s
      set_cookie
    end

    # Delete a crumb sub-part from a cookie
    def delete(name)
      @crumbs.delete name.to_s
      set_cookie
    end

    private
      def set_cookie #:nodoc:
        @cookie[@name] = @crumbs
      end
  end
end
