
#
# This is an example VCL file for Varnish.
#
# It does not do anything by default, delegating control to the
# builtin VCL. The builtin VCL is called when there is no explicit
# return statement.
#
# See the VCL chapters in the Users Guide at https://www.varnish-cache.org/docs/
# and https://www.varnish-cache.org/trac/wiki/VCLExamples for more examples.

# Marker to tell the VCL compiler that this VCL has been adapted to the
# new 4.0 format.
vcl 4.0;
import directors;    # load the directors
import std;

backend web1_backend { .host = "web1"; .port = "8080"; }
backend web2_backend { .host = "web2"; .port = "8080"; }
backend web3_backend { .host = "web3"; .port = "8080"; }



backend web1_ssl_backend { .host = "web1"; .port = "443"; }
backend web2_ssl_backend { .host = "web2"; .port = "443"; }
backend web3_ssl_backend { .host = "web3"; .port = "443"; }



sub vcl_init {
    new webs = directors.round_robin();
    webs.add_backend(web1_backend);
    webs.add_backend(web2_backend);
    webs.add_backend(web3_backend);
    new webs_ssl = directors.round_robin();
    webs_ssl.add_backend(web1_ssl_backend);
    webs_ssl.add_backend(web2_ssl_backend);
    webs_ssl.add_backend(web3_ssl_backend);
}


#director default_director round-robin {
#  { .backend = web1_backend; }
#  { .backend = web2_backend; }
#  { .backend = web3_backend; }
#}

#director ssl_director round-robin {
#  { .backend = web1_ssl_backend; }
#  { .backend = web2_ssl_backend; }
#  { .backend = web3_ssl_backend; }
#}


# Default backend definition. Set this to point to your content server.
#backend default {
#    .host = "127.0.0.1";
#    .port = "8080";
#}



sub vcl_recv {
std.log(client.ip);
    # Happens before we check if we have this in cache already.
    #
    # Typically you clean up the request here, removing cookies you don't need,
    # rewriting the request, etc.
# if (req.port == 443) {
    #set req.backend = ssl_director;
 #    set req.backend_hint = webs_ssl.backend();
 # }
  #else {
    #set req.backend = default_director;
     set req.backend_hint = webs.backend();
	#set req.http.X-Forwarded-For = client.ip;
#if (req.http.X-Forwarded-For) {
    #    set req.http.X-Forwarded-For = req.http.X-Forwarded-For;
 #   } else {
  #      set req.http.X-Forwarded-For = client.ip;
 #   }    
    set req.http.x-clientip = client.ip;
    set req.http.x-serverip = server.ip;
    set req.http.x-localip = local.ip;
    set req.http.x-remoteip = remote.ip;
    return(pass);
#}
}

sub vcl_backend_response {
    # Happens after we have read the response headers from the backend.
    #
    # Here you clean the response headers, removing silly Set-Cookie headers
    # and other mistakes your backend does.
}

sub vcl_deliver {
    # Happens when we have all the pieces we need, and are about to send the
    # response to the client.
    #
    # You can do accounting or modifying the final object here.
}
