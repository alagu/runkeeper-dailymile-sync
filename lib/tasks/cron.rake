desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  User.active.each do |user|
    runkeeper = Runkeeper.new(user.runkeeper_id)
    activities = runkeeper.activities(:since => user.last_activity_id).reverse

    activities.each do |activity|
      User.transaction do
        begin
          response = Dailymile.post("/entries.json?oauth_token=#{user.access_token}", :query => activity.to_dailymile)
          user.update_attribute(:last_activity_id, activity.id)
          user.activities.create(:content => activity.as_json, :success => true, :response => response)
        rescue Exception => e
          user.activities.create(:content => activity.as_json, :success => false, :response => response)
        end
      end
    end
  end
end
