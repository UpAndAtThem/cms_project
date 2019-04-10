require "sinatra"
require "sinatra/reloader" if development?
require "sinatra/content_for"
require "tilt/erubis"
require "pry"
require "find"
require "redcarpet"

configure do
  enable :sessions
  set :session_secret, 'super secret'
end

def data_path
  if ENV["RACK_ENV"] == "test"
    File.expand_path("../test/data", __FILE__)
  else
    File.expand_path("../data", __FILE__)
  end
end

def render_markdown(text)
  markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  markdown.render(text)
end

before do
  @root = File.expand_path("..", __FILE__)
  file_path = File.join data_path, "*"

  @files = Dir.glob(file_path).map do |path|
             File.basename(path)
           end
end

get "/" do
  pattern = File.join(data_path, "*")
  erb :files
end

def load_file_content(path)
  content = File.read(path)
  case File.extname(path)
  when ".txt"
    headers["Content-Type"] = "text/plain"
    content
  when ".md"
    erb render_markdown(content)
  when ".rb"
    headers["Content-Type"] = "text/plain"
    content
  end
end

get "/new_file" do
  erb :new_file
end

get "/sign_in" do
  erb :sign_in
end

get "/:file_name" do
  @file_name = params['file_name']
  file_path = File.join(data_path, @file_name)
  session[:hello] = "whatup"
  binding.pry
  if @files.include? @file_name
    load_file_content file_path
  else
    session[:error] = "#{@file_name} does not exist"
    redirect "/"
  end
end

get "/:file_name/edit_file" do
  @file_name = params['file_name']
  file_path = File.join(data_path, @file_name)

  if @files.include? @file_name
    @file = File.read(file_path)
    erb :edit_file
  else
    session[:error] = "#{@file_name} does not exist"
    redirect "/"
  end
end

post "/:file_name/edit_file" do
  file_name = params[:file_name]
  file_path = File.join(data_path, file_name)

  file = File.open(file_path , "w") do |f|
    f.write params[:fileContents]
  end

  session[:success] = "#{params[:file_name]} has been updated"
  redirect "/"
end

post "/new_file" do
  file_name = params[:file_name]
  file_path = File.join(data_path, file_name)
  
  unless file_name.empty?
    File.write(file_path, "")
    session[:success] = "File: #{params[:file_name]} has been created"
    status 302
    redirect "/"
  else
    session[:error] = "The file name must be provided."
    status 422
    erb :new_file
  end
end

post "/delete/:file_name" do
  file_name = params[:file_name]
  path = data_path
  if @files.include? file_name
    File.delete(File.join(path, file_name))
    session[:success] = "#{file_name} has been deleted."
    redirect "/"
  else
    status 422
    session[:error] = "The file could not be found to be deleted"
    erb :files
  end
end

post "/sign_in" do
  session[:username] = params[:username]
  @username = session[:username]
  password = params[:password]

  if session[:username] == 'admin' && password == 'secret'
    session[:signed_in] = true
    session[:success] = "Welcome!"
    redirect "/"
  else
    session[:error] = "Wrong username or password"
    erb :sign_in
  end
end

post "/sign_out" do
  session[:signed_in] = false
  session[:success] = "You have been signed out."
  redirect "/"
end
