class Runner < ApplicationRecord
  attr_accessor :name, :path, :os, :uid

  def to_json
    {
      name: @name,
      path: @path,
      os: @os,
      uid: @id
    }.to_json
  end
end
