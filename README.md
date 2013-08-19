# router.js
Simple, light-weight, library independant, JavaScript router. Triggers callbacks based on URIs.
Supports fixed, optional and splat parameters.

## Usage

### Initalise the router

    router = new Router();

### Add routes
You add routes via the add method.

#### Static

    router.add('/', function() {
      alert('Welcome to the home page!');
    });
    
    router.add('/test', function() {
      alert('Welcome to the test page!');
    });

#### Fixed Parameters
The example below will match **/people/1234**.

    router.add('/people/:id', function(id) {
      alert('Your ID is: ' + id);
    });

#### Optional Parameters
By wrapping a parameter with () you can make them optional.
The example below will match both **/people** and **/people/1234**.

    router.add('/people(/:id)', function(id) {
      if (id == null) {
        alert('No ID provided);
      } else {
        alert('Your ID is: ' + id);
      }
    });

#### Splat Parameters
By adding a + to a parameter you can make it a splat. Splats soak up all following URI segments and always return an array. The example below will match **/people/lookup/mike/james/john** and **/people/lookup/jimbo**.

    router.add('/people/lookup/:names+', function(names) {
      alert('Looking for: ' + names.join(', '));
    });

### Match routes
This tells the router you want to check the routes against the current URI. Routes are matched in the order they were added. You'll want to fire this on page load or when the DOM is ready. It could also be fired on popstate if your using HTML5 pushstate.

    router.visit();

You can optionally pass a URI to check against.

    router.visit('/my/test/route');

## License
MIT licensed

Copyright (C) 2013 Mike Simmonds, [http://simmo.me](http://simmo.me)
