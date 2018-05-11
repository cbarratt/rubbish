require_dependency './lib/collection_dates'

class Api::CollectionController < Api::BaseController
  def index
    collections = { dates: ::CollectionDates.fetch(params[:postcode]) } if params[:postcode]
    collections = { error: 'No postcode provided' } if params[:postcode].empty?

    render json: collections
  end
end
