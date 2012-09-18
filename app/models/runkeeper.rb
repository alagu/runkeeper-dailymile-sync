class Runkeeper
  BASE_URL = "http://runkeeper.com"

  attr_reader :username, :profile_url

  def initialize(username)
    @username = username
    @profile_url = "#{BASE_URL}/user/#{username}"
    @agent = Mechanize.new
    begin
      @profile_page = agent.get(profile_url)
    rescue Exception => e
      puts "ERROR: #{e.message}. URL: #{profile_url}"
      return nil
    end
  end

  def activities(options = {})
    options[:limit] ||= 10
    options[:since] ||= 0

    @limit = options[:limit]
    @since = options[:since]

    activity_list = []
    begin
      page = agent.get(activities_url)
      puts "Done fetching page"
    rescue Exception => e
      puts "ERROR: #{e.message}. URL: #{activities_url}"
      return []
    end

    page.search("div.feedItem.clickable").each do |activity_entry|
      activity_url = "#{BASE_URL}#{activity_entry.attr('data-link')}"
      
      if not activity_url.index('activity_redirect').nil?
        puts "Fetching #{activity_url}"
        begin
          activity_page = agent.get(activity_url)
          activity_id = activity_page.uri.to_s.split('/').last.to_i
          if activity_id < @since
            next
          end
          puts "Doing #{activity_page.uri.to_s}"
          activity = Activity.new(activity_page)
          activity.url = activity_page.uri.to_s
          activity_list << activity
        rescue Exception => e
          puts "ERROR: #{e.message}. URL: #{activity_url}"
          puts "#{e.backtrace}"
        end
      end
    end
    activity_list
  end

  def activities_url
    @activities_url ||= "#{BASE_URL}/user/#{username}"
  end

  private

  def agent
    @agent
  end
end
