class MerryBacklog < Backlog
  # TODO: 設定ファイルに移動
  CONF = Hashie::Mash.new({
    proj: {
      pkey: 'MERRY_DIET',
      name: 'メリーさんのダイエット講座'
    },
    priority: { name: '高' },
    issue_type: {
      name: 'メリータスク',
      color: '#e30000'
    }
  })

  def initialize(space_id, token)
    super(space_id, token)
  end

  def get_or_create_proj
    get_proj || create_proj
  end

  def set_proj_infos(_proj)
    _proj['priority'] = get_priority
    _proj['issue_type'] = get_or_create_issue_types(_proj.id)
    _proj
  end

  def get_tasks(id)
    task.all(id).select {|t| t.issueType.name == CONF.issue_type.name}
  end

  private
  def get_proj
    proj.all.select {|r| r.projectKey == CONF.proj.pkey}.first
  end

  def create_proj
    conf = CONF.proj
    proj.create(conf.key, conf.name)
  end

  def get_priority
    proj.priorities.select {|p| p.name == CONF.priority.name}.first
  end

  def get_or_create_issue_types(id)
    get_issue_type(id) || create_issue_type(id)
  end

  def get_issue_type(id)
    proj.issue_types(id).select {|i| i.name == CONF.issue_type.name}.first
  end

  def create_issue_type(id)
    conf = CONF.issue_type
    proj.add_issue_type(id, conf.name, conf.color)
  end
end

module BacklogKit
  class Resource
    def [](idx)
      @attributes[idx]
    end

    def []=(idx, val)
      @attributes[idx] = val
    end

    def each
      @attributes.each {|k, v| yield k, v }
    end
  end
end
