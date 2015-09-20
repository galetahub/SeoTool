require "sinatra/base"
require 'httparty'

require_relative "seo_tool"

module SeoToolApp
  class Application < Sinatra::Base
    # Configuration
    set :views, File.dirname(File.expand_path('../../', __FILE__)) + '/views'
    set :public_folder, File.dirname(
      File.expand_path('../../', __FILE__)) + '/public'

    get '/' do
      @seo = SeoTool.new(params)
      @site_list = @seo.generate_site_list
      slim :index
    end

    post '/show' do
      begin
        response = HTTParty.get(params[:url])
        if response.success?
          @seo = SeoTool.new(params)
          @seo_body = @seo.analize
          slim :report_template
        end
      rescue
        redirect "/error"
      end
    end

    get '/report/:filename' do
      path = File.expand_path('../../../public/reports', __FILE__)
      page = path + '/' + params[:filename]
      send_file page
    end

    get '/error' do
      slim :error
    end

  end
end
