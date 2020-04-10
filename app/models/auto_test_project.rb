class AutoTestProject < ApplicationRecord
  attr_accessor :name, :path, :description
  has_many :student_test_records, dependent: :destroy
  belongs_to :classroom

  validates :gitlab_id, presence: true, uniqueness: true

  def initialize(*args)
    super
  end

  def to_json
    {
        name: @name,
        path: @path,
        description: @description
    }.to_json
  end
end
