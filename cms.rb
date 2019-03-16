require "sinatra"
require "sinatra/reloader" if development?
require "sinatra/content_for"
require "tilt/erubis"
require 'pry'
require "find"

before do
  @files_directory = Find::find("./public/data")
  @file_names = Dir.foreach("./public/data").select { |x| File.file?("./public/data/" + x)}.sort
end

get "/" do
  erb :files
end

get "/:file_name" do
  @file_name = params['file_name']

  #headers["Content-Type"] = "text/plain"
  @file = File.read("./public/data/#{@file_name}")

  erb :file
end