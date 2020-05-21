class Runner < ApplicationRecord
  validates :uid, uniqueness: { case_sensitive: false}

  def to_json
    {
      name: @name,
      path: @path,
      os: @os,
      uid: @id
    }.to_json
  end
end
