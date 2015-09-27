module SeoTools
  class Link
    attr_accessor :number, :title, :href, :rel, :target, :download

    def initialize(number, title, href, rel, target, download)
      @title = title
      @href = href
      @rel = rel
      @target = target
      @download = download
      @number = number
    end
  end
end
