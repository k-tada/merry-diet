module TasksHelper
  def today?(t)
    Date.parse(t.when) == Date.today
  end
end
