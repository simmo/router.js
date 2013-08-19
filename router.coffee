class Route
  _pattern_to_regexp = ->
    # 1. Make optional params, er, optional
    @route = @pattern.replace(')', ')?')
    
    # 2. Find all params, log and replace with regexp
    param_keys = []
    @route = @route.replace /:(\w+)\+?/g, (match, name) ->
      param_key =
        name: name
        regex: match
        is_splat: false
      
      # Is the param a splat (+)
      if match.substr(-1) is '+'
        param_key.is_splat = true
        replace_with = '(.+)'
      else
        replace_with = '([^\/]+)'
      
      # Add new param key to the list
      param_keys.push(param_key)
      
      # Return the regexp replacment
      replace_with
    
    @param_keys = param_keys
    
    # 3. Make the trailing slash optional
    @route += '?' if @route.substr(-1) is '/'
    
    # 4. Add start and end
    @route = '^' + @route + '$'
  constructor: (@pattern, @callback) ->
    @params = []
    
    # Convert pattern to regex
    _pattern_to_regexp.call(@)
    
  matches: (uri = window.location.pathname) ->
    # Return false if no matches
    return false unless (matches = uri.match(@route)) and matches.length
    
    # Clean up the values - if JS every allows named subpatterns this can go
    param_values = []
    for match in matches
      param_values.push(match) unless typeof match is 'undefined' or match.substr(0, 1) is '/'
    
    # If the param key is a splat (+) then convert value to an array
    for match, index in param_values
      @params.push(if @param_keys[index].is_splat then match.split('/') else match)
    
    # We have a match!
    return true

class Router
  constructor: -> @routes = []
  add: (route, callback) ->
    # Add route
    @routes.push(new Route(route, callback))
    
    # Allow chaining
    @
  visit: (uri = window.location.pathname) ->
    # Check if each route matches
    for route in @routes
      route.callback.apply(route, route.params) if route.matches()
