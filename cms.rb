require "sinatra"
require "sinatra/reloader" if development?
require "sinatra/content_for"
require "tilt/erubis"
require 'pry'
require "find"

before do
  @root = File.expand_path("..", __FILE__)
  @files_directory = Find::find("./public/data")
  @file_names = Dir.foreach("#{@root}/public/data").select { |x| File.file?("./public/data/" + x)}.sort
end

get "/" do
  erb :files
end

get "/:file_name" do
  @file_name = params['file_name']

  if @file_names.include? @file_name
    @file = File.read("#{@root}/public/data/#{@file_name}")
    erb :file
  else
    session[:error] = "#{@file_name} does not exist"
    erb :files
  end
end