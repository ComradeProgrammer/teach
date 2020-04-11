class Broadcast < ApplicationRecord

  def to_json
    {
        to_id: @to_id,
        content: @content
    }.to_json
  end
end
