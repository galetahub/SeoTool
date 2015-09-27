require "sinatra/base"
require 'httparty'

require_relative "report_generator/report"
require_relative "report_generator/report_generator"
require_relative "storage/storage_provider"


module SeoTools
  class Application < Sinatra::Base
    include Storage
    # Configuration
    set :views, File.dirname(File.expand_path('../../', __FILE__)) + '/views'
    set :public_folder, File.dirname(
      File.expand_path('../../', __FILE__)) + '/public'

    get '/' do
      sp = StorageProvider.new
      @site_list = sp.all
      puts @site_list
      slim :index
    end

    post '/show' do
      #begin
        response = HTTParty.get(params[:url])
        if response.success?
          @rg = ReportGenerator.new(params)
          @report = @rg.generate
          slim :report_template
        else
          redirect "/error"
        end
      #rescue
      #
      #end
    end

    get '/report/:id' do
      id = params[:id]
      sp = StorageProvider.new
      @report = sp.find(id)
      if @report.is_a(Report)
        slim :report_template
      else
        send_file @report
      end
    end

    get '/error' do
      slim :error
    end

  end
end
