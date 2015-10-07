class Task
  include ActiveModel::Model

  attr_accessor :when, :distance

  validates :when, presence: true
  validates :distance, presence: true

  def to_json
    {when: self.when, distance: self.distance}.to_json
  end

  def get_date
    date = DateTime.parse(self.when).strftime('%Y-%m-%d')
  end
end
