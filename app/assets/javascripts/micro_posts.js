# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


// Don't start refreshing unless we are on the home page
if (window.location.pathname === '/static_pages/home'
    || window.location.pathname === '/') {
  
  // function we will call regularly to update the feed
  var refresh_micro_posts = function () {
    
    // return immediately if we aren't on the first page of results
    var query_string = window.location.search;
    if (query_string.indexOf("page=") > -1
        && query_string.indexOf("page=1") === -1) {
      return;
    }
    
    // Retrieve the set of post ids currently visible from the home page
    var post_ids = [];
    $('#user_feed p').each(function (i, p) {
      // each id looks like "micro_post_1234"; we just want the number
      // so we split it up and take the part we need
      var post_id = parseInt(p.id.split("_")[2]);
      post_ids.push(post_id);
    });
    
    // Issue the AJAX request; the JavaScript generated by the server
    // will be evaluated, inserting new posts into the page (if necessary)
    $.ajax({
      dataType: 'script',
      url: '/micro_posts/refresh',
      data: {
        ids: post_ids
      }
    });
  };
  
  
  // Begin polling our server every 5 seconds for fresh MicroPosts
  setInterval(refresh_micro_posts, 5000);
}