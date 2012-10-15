desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  User.public.active.each do |user|
    runkeeper = Runkeeper.new(user.runkeeper_id)
    next if runkeeper.nil?
    activities = runkeeper.activities(:since => user.last_activity_id).reverse

    activities.each do |activity|
      User.transaction do
        begin
          puts "Posting content"
          puts "#{activity.to_dailymile}"
          response = Dailymile.post("/entries.json?oauth_token=#{user.access_token}", :query => activity.to_dailymile)
          user.update_attribute(:last_activity_id, activity.id)
          user.activities.create(:content => activity.as_json, :success => true, :response => response)
          puts response
        rescue Exception => e
          puts e
          puts e.message
          puts e.backtrace
          user.email "Runkeeper #{e}", "#{e.message} #{e.backtrace}"
          user.activities.create(:content => activity.as_json, :success => false, :response => response)
        end
      end
    end
  end
end
