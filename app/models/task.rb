class Task
  include ActiveModel::Model

  attr_accessor :id, :when, :distance

  validates :id, presence: true
  validates :when, presence: true
  validates :distance, presence: true

  def initialize(arg = {})
    params = {id: arg.issueKey}.merge(JSON.parse(arg.description).reject{|k, v| k == 'user_id'}) if arg.is_a?(BacklogKit::Resource)
    super(params || arg)
  end

  def to_hash
    {when: self.when, distance: self.distance}
  end

  def get_date
    date = DateTime.parse(self.when).strftime('%Y-%m-%d')
  end

  def future?
    Time.zone.parse(self.when).to_datetime >= Time.zone.now
  end
end
