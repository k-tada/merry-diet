namespace :twilio do
  desc "Twilio"
  task call: :environment do
    # 課題抽出範囲（現在日時の10分後〜70分後）
    from = 10.minutes.since
    to = 70.minutes.since
    # 非効率だけど仕方ない
    users = User.select(:id, :token, :refresh_token, :space_id, :phone_number).distinct
    users.each do |user|
      backlog = MerryBacklog.new(user.space_id, user.token)
      begin
        proj = backlog.get_proj
      rescue BacklogKit::Error => e
        # 認証切れの場合を考慮して、Tokenリフレッシュ処理を行う
        retry_errors = ['token expired.', 'Authentication failure.']
        if retry_errors.any? {|m| e.message.include?(m)}
          refresh_hash = Hashie::Mash.new(backlog.refresh_token(user))

          # リフレッシュ済みトークンでユーザマスタを更新する
          User.find_by_id(user.id).update!(token: refresh_hash.access_token, refresh_token: refresh_hash.refresh_token)
          backlog = MerryBacklog.new(user.space_id, refresh_hash.access_token)
          proj = backlog.get_proj
        else
          raise e
        end
      end

      # 日時で課題を抽出
      tasks = backlog
                .get_today_tasks
                .select {|t| t.status.name != '完了'}
                .map {|t|
                  desc = Hashie::Mash.new(JSON.parse(t.description))
                  time = Time.zone.parse(desc.when).to_datetime
                  Hashie::Mash.new({datetime: time, distance: desc.distance})
                }.select {|t| from <= t.datetime && t.datetime <= to }

      tasks.each do |task|
        MerryTwilio.new.call_to(user.phone_number, task.datetime, task.distance)
      end
    end
  end
end
