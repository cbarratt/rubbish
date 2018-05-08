class Api::CollectionController < Api::BaseController
  include CollectionDates

  def index
    collections = Rails.cache.fetch("dates", expires_in: 60.minutes) do
      fetch
    end

    render json: { dates: collections }
  end
end
