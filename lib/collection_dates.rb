module CollectionDates
  class << self
    def fetch(postcode)
      if fetch_from_db(postcode) == nil
        fetch_from_source(postcode)
        fetch_from_db(postcode)
      end

      fetch_from_db(postcode)
    end

    def fetch_from_source(postcode)
      doc = Nokogiri::HTML(get_page_html)

      collection_dates = doc.css('.mb10 .ind-waste-wrapper', '.col-sm-4').map do |date|
        date.children[1].content if date.children[1]
      end.compact

      collection_dates.slice!(0..1).each do |string|
        Collection.first_or_create(
          postcode: postcode,
          bin_type: 'household',
          date: parse_date(string)
        )
      end

      collection_dates.slice!(0..1).each do |string|
        Collection.first_or_create(
          postcode: postcode,
          bin_type: 'mixed',
          date: parse_date(string)
        )
      end

      collection_dates.slice!(0..1).each do |string|
        Collection.first_or_create(
          postcode: postcode,
          bin_type: 'garden',
          date: parse_date(string)
        )
      end
    end

    def fetch_from_db(postcode)
      {
        household: Collection.where(postcode: postcode).household.pluck(:date),
        mixed: Collection.where(postcode: postcode).mixed.pluck(:date),
        garden: Collection.where(postcode: postcode).garden.pluck(:date)
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
