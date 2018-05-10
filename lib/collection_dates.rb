module CollectionDates
  class << self
    def fetch
      doc = Nokogiri::HTML(get_page_html)

      collection_dates = doc.css('.mb10 .ind-waste-wrapper', '.col-sm-4').map do |date|
        date.children[1].content if date.children[1]
      end.compact

      {
        household: collection_dates.slice!(0..1).map { |string| parse_date(string) }.sort,
        mixed: collection_dates.slice!(0..1).map { |string| parse_date(string) }.sort,
        garden: collection_dates.slice!(0..1).map { |string| parse_date(string) }.sort
      }
    end

    def get_page_html
      HTTP.get('http://www.wakefield.gov.uk/site/Where-I-Live-Results?uprn=63004110').to_s
    end

    def parse_date(string_date)
      return Date.today.to_s if string_date == 'Today'
      return Date.yesterday.to_s if string_date == 'Yesterday'

      Date.parse(string_date).to_s
    end
  end
end
