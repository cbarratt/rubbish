require_dependency './lib/collection_dates'

class Api::CollectionController < Api::BaseController
  def index
    collections = Rails.cache.fetch("dates", expires_in: 60.minutes) do
      ::CollectionDates.fetch
    end

    render json: { dates: collections }
  end
end
