require 'spec_helper'
require 'app'

include SeoToolApp

describe Application do
  def app
    a = described_class.allocate
    a.send :initialize
    a
  end

  describe "get '/'" do
    it "returns home page" do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.body).to include("Perform")
    end
  end

  describe "post '/show'" do
    it "generates and shows a page with report" do
      post "/show", :url => "https://vk.com"
      expect(last_response).to be_ok
      expect(last_response.body).to include("Headers")
    end
  end

  describe "post '/report/:filename'" do
    it "redirect to a page with a report" do
      get "/report/serkalayder.html"
      expect(last_response).to be_ok
      expect(last_response.body).to include("Headers")
    end
  end

  describe "get '/error" do
    it "returns error message if input was incorrect" do
      get "/error"
      expect(last_response).to be_ok
      expect(last_response.body).to include("Error has occured.")
    end
  end

end
