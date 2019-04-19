## HTTP

HTTP which stands for HyperText Transfer Protocol is a stateless request/response protocol, and is the standard format for how messages are defined and transmitted over the web. clients make requests to web servers over the internet using HTTP. Web servers respond to those client requests also through HTTP. HTTP is used at the application layer, and runs on top of TCP/IP (the transport and network layers) 

## TCP/IP

#### TCP
Transport Layer Protocol. It provides the delivery between clients and servers communicating by IP

#### IP
Internet Layer Protocol. It uses IP Adresses to deliver data from the source to destination

## HTTP REQUEST AND RESPONSE COMPONENTS

#### HTTP REQUEST
A request is sent to a host, the request includes a request line, which is the http method and path for the requested resource.  a request also contains a host header. It may also contain parameters, additional headers, and a body. 

#### HTTP RESPONSE
The Server processes the request and sends back a status number (200 OK, 404 Not Found), response headers (optional), and a body (optional) as a response.

## COMPONENTS OF URL

A url contains many parts. (ex: http://www.foobar.gov:80/cartoon/disney?name=Donald+Duck&age=88)

scheme - http
host - www.foobar.gov
port - :80 (port 80 common for http)
path - /cartoon/disney
query string - ?name=Donald+Duck&age=88 (begins with ? then paramaters of key value pairs separated by an =. and each parameter separated by an &)

## GET vs POST

The HTTP methods get and post both have their own purposes.

#### GET
GET requests are used to get a resource. GET requests should only retrieve content from the server and not send, update or create data. The exception being search engine search bar client requests

GET request are used for things such as requesting html for a webpage, requesting a resource (image, video, software), an action that you are trying to get something from the host server.

#### POST
POST requests are used to submit and send data, and initiate some action, such as submitting forns, editing or deleting data from the server, etc. The data is not submitted by query string, but rather inside the optional body of the HTTP message.

POST requests involve changing, deleting, and creating values that are stored and persist on the server.

## CLIENT VS SERVER

the client/server model is the structure that describes the interaction over the web between resource/service providers and those making requests to said providers. 

#### CLIENT
Any software (most commonly web-browsers) that interacts and makes HTTP requests over the web. And displays the response in a meaningful way back to the user.

#### SERVER
Computers whose purpose is to accept and handle requests for an action or resource, and then in turn do work, and issue a response back to the client.

## CLIENT VS SERVER CODE
#### CLIENT CODE
client code is the javascript, html and css
#### SERVER CODE

config.ru - in a Rack application the config.ru or rackup file (a file with the extention .ru) is the startup code for a rack application. It specifies what application to run and how to run the application. It lives in the root of the project that instructs the web server how to start the application.

cms.rb (application code) - This file contains all the Sinatra routes (GET, POST, DELETE, etc), Sinatra helpers, and Sinatra configuration settings (like enabling sessions, setting session secret, etc)

Gemfile - is used for describing all of the gems and their version used (with various operators to distinguish version(s) allowed) in the Ruby project. It can group gem dependencies, and is used to define which version of Ruby is used

``` ruby  
source "https://rubygems.org"

ruby "2.4.1"

gem "sinatra", "~>1.4.7"
gem "sinatra-contrib"
gem "erubis"

group :production do
  gem "puma"
end

```  
Procfile - this tells Heroku how to run components of the application, it specifies the commands that are executed, declaring the process type, and command. 

``` ruby  
web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}
```  

The part to the left of the colon on each line is the process type. The part on the right is the command to run to start that process (setting up web server puma)

## WEB

#### HTML FORMS

What happens behind the scence when a user clicks submit on a web form containing text input?

A form is an html element that allows users to enter, check, select data which is then sent to a web server for processing.

#### FORM

The opening `<form>` tag has the following attributes.

Action- this points to the route the server side application code handles.

ex: `<form action='/new_user'>`

Method- defines the HTTP method used in the form request. 

ex: `<form method='post'>`

The default method is GET. If GET is used, the form passes the form data as URL parameters. If POST is the method used, the form data is sent in the body of the request.

#### INPUT

input elements of various types are placed in between the opening and closing form tags. The opening `<input>` tag has the following attributes (not an exhaustive list).

Type- This tells what kind ofinput should be created.

Name- This gives a name to the specific input field, and helps to identify and understand the data on the server side.

Value- This is the default value that shows up on load.

ex: `<input type="text" name="user_name" value="enter name">`