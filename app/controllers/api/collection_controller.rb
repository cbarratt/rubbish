class Api::CollectionController < Api::BaseController
  def index
    collections = { dates: ::CollectionDates.fetch(params[:postcode]) } if params[:postcode]
    collections = { error: 'No postcode provided' } if params.dig(:postcode).blank?

    render json: collections
  end
end
