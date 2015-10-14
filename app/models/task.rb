class Task
  include ActiveModel::Model

  attr_accessor :when, :distance

  validates :when, presence: true
  validates :distance, presence: true

  def initialize(arg = {})
    params = JSON.parse(arg.description).reject{|k, v| k == 'user_id'} if arg.is_a?(BacklogKit::Resource)
    super(params || arg)
  end

  def to_hash
    {when: self.when, distance: self.distance}
  end

  def get_date
    date = DateTime.parse(self.when).strftime('%Y-%m-%d')
  end
end
