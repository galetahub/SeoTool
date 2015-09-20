module SeoToolApp
  class SeoBody
    attr_accessor :title, :url, :date, :headers, :links

    def initialize(title, url, date, headers, links)
      @title = title
      @url = url
      @date = date
      @headers = headers
      @links = links
    end

  end
end
