class Runkeeper
  BASE_URL = "http://runkeeper.com"

  attr_reader :username, :profile_url

  def initialize(username)
    @username = username
    @profile_url = "#{BASE_URL}/user/#{username}"
    @agent = Mechanize.new
    @profile_page = agent.get(profile_url)
  end

  def activities(options = {})
    options[:limit] ||= 10
    options[:since] ||= 0

    @limit = options[:limit]
    @since = options[:since]

    activity_list = []
    page = agent.get(activities_url)

    page.search("div.activityMonth").each do |activity_entry|
      activity_url = "#{BASE_URL}#{activity_entry[:link]}"
      activity_id = activity_entry[:link].split('/').last
      if activity_id.to_i > @since
        puts "fetching #{activity_url}"
        activity_page = agent.get(activity_url)
        activity = Activity.new(activity_page)
        activity.url = activity_url
        activity_list << activity
        return activity_list if activity_list.size >= @limit
      end
    end
    activity_list
  end

  def activities_url
    @activities_url ||= "#{BASE_URL}/user/#{username}/activity"
  end

  private

  def agent
    @agent
  end
end
