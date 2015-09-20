module SeoToolApp
  class SiteListItem
    attr_accessor :link, :date, :relative_link

    def initialize(link, date, relative_link)
      @link = link
      @date = date
      @relative_link = relative_link
    end
  end
end
