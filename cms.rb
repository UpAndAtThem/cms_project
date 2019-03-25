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
  end
end

get "/:file_name" do
  @file_name = params['file_name']
  file_path = File.join(data_path, @file_name)

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

