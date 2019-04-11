ENV["RACK_ENV"] = "test"

require 'minitest/autorun'
require 'rack/test'
require 'pry'
require "tilt/erubis"
require "fileutils"

require_relative "../cms.rb"

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def setup
    FileUtils.mkdir_p(data_path)
  end

  def teardown
    FileUtils.rm_rf(data_path)
  end

  def app
    Sinatra::Application
  end

  def session
    last_request.env["rack.session"]
  end

  def create_document(name, content = "")
    File.open(File.join(data_path, name), "w") do |file|
      file.write(content)
    end
  end

  def test_index
    create_document "about.md", "about.md"
    create_document "changes.txt", "changes.txt"

    get_res = get "/", {}, {message: "This is the message"}

    assert_equal 200, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
    assert_includes last_response.body, "about.md"
    assert_includes last_response.body, "changes.txt"
  end

  def test_about_page
    create_document "about.md", "Early Concept"
    get "/about.md"

    assert_includes(last_response.body, "Early Concept")
  end

  def test_nonexistant_route
    get "/not_a_file.md"
    redirected_request = get "/"

    assert_includes(redirected_request.body, "not_a_file.md does not exist")
  end

  def test_edit_document
    create_document "about.md"

    post_res = post "/about.md/edit_file"
    get_redirect_res = get "/"

    assert_includes get_redirect_res.body, "about.md has been updated"
    assert_equal post_res.status, 302
  end

  def test_new_document_creation
    post_res = post "/new_file?file_name=this.md"

    assert_includes "File: this.md has been created", session[:success]
    assert_equal post_res.status, 302
  end

  def test_new_document_fail
    post_res = post "/new_file", {"file_name" => ""}, {"rack.session" => {message: "new message from test"}}

    assert_equal post_res.status, 422
    assert_includes post_res.body, "The file name must be provided."
  end

  def test_delete_document
    create_document "document.md"
    post_res = post "/delete/document.md"

    assert_includes session[:success], "document.md has been deleted"
    assert_equal 302, post_res.status
  end

  def test_delete_fail
    post_res = post "/delete/document.notreal"

    assert_equal 422, post_res.status
    assert_includes post_res.body, "The file could not be found to be deleted"
  end

  def test_sign_in
    res = post "/sign_in", {message: "sign in message"}
  end
end