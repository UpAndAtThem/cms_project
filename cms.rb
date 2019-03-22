require "sinatra"
require "sinatra/reloader" if development?
require "sinatra/content_for"
require "tilt/erubis"
require 'pry'
require "find"
require "redcarpet"

configure do
  enable :sessions
  set :session_secret, 'super secret'
end

def render_markdown(text)
  markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  markdown.render(text)
end

before do
  @root = File.expand_path("..", __FILE__)
  @files = Dir.glob(@root + "/public/data/*").map do |path|
             File.basename(path)
           end
end

get "/" do
  erb :files
end

get "/:file_name" do
  @file_name = params['file_name']

  if @files.include? @file_name
    @file = File.read("#{@root}/public/data/#{@file_name}")
    render_markdown @file
  else
    session[:error] = "#{@file_name} does not exist"
    redirect "/"
  end
end

get "/:file_name/edit_file" do
  @file_name = params['file_name']

  if @files.include? @file_name
    @file = File.read("#{@root}/public/data/#{@file_name}")
    erb :edit_file
  else
    session[:error] = "#{@file_name} does not exist"
    redirect "/"
  end
end

post "/:file_name/edit_file" do
  file = File.open("#{@root}/public/data/#{params[:file_name]}", "w") do |f|
    f.write params[:fileContents]
  end
  session[:success] = "#{params[:file_name]} has been updated"
  redirect "/"
end