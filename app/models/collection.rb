class Collection < ApplicationRecord
  enum bin_type: [
    :household,
    :mixed,
    :garden
  ]
end
