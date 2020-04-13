class AutoTestProject < ApplicationRecord
  attr_accessor :name, :path, :description, :type
  has_many :student_test_records, dependent: :destroy
  belongs_to :classroom

  validates :gitlab_id, presence: true, uniqueness: true

  def initialize(*args)
    super(nil)
    print(args.length)
    if args.length > 0
      @type = args[0]
    end
  end

  def to_json
    {
        name: @name,
        path: @path,
        description: @description,
        type: @type
    }.to_json
  end
end
