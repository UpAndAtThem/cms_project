require "sinatra"
require "sinatra/reloader" if development?
require "sinatra/content_for"
require "tilt/erubis"
require 'pry'
require "find"

get "/" do
  @files_directory = Find::find("./public/files")
  @file_names = Dir.foreach("./public/files").select { |x| File.file?("./public/files/" + x)}.sort
  
  erb :files
end