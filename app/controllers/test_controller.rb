require 'nokogiri'
require 'open-uri'
require 'pry'

class TestController < ApplicationController
  def index
    blah = collection_day

    render json: { dates: blah }
  end

  def collection_day
    doc = Nokogiri::HTML(open('http://www.wakefield.gov.uk/site/Where-I-Live-Results?uprn=63004110'))

    collection_dates = doc.css('.mb10 .ind-waste-wrapper', '.col-sm-4').map do |date|
      date.children[1].content if date.children[1]
    end.compact

    {
      household: collection_dates.slice!(0..1).sort_by { |string| Date.parse(string) },
      mixed: collection_dates.slice!(0..1).sort_by { |string| Date.parse(string) },
      garden: collection_dates.slice!(0..1).sort_by { |string| Date.parse(string) }
    }
  end
end
