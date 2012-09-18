class Runkeeper
  class Activity
    include ActiveModel::Serialization

    attr_accessor :id, :url, :distance, :duration, :average_pace, :average_speed,
      :calories, :climb, :begins_at, :ends_at, :notes

    def calculate_speed(pace)
      mins  = pace.split(':').first.to_i
      secs  = pace.split(':').last.to_i
      mins  = mins + secs/60.0
      speed = (60.0/mins)
      "%0.2f" % speed
    end

    def initialize(page)
      @id            = page.uri.to_s.split('/').last
      @distance      = page.search('div#stats div').text.split('km').first
      @duration      = page.search('div#stats ul li').first.text.split('!').last
      @average_pace  = page.search('div#stats ul li')[2].text.split(' ').first.split('@').last
      @average_speed = calculate_speed(@average_pace) 
      @calories      = page.search('div#stats ul li')[1].text.split(' ').first.split('"').last
      @climb = "0"

      date = page.search('#mainContent #details #number p').text.split("\n").first
      start_date, year, times = date.split(',')
      start_time, end_time = times.split('-')

      @begins_at = Time.parse("#{start_date} #{year} #{start_time}")
      @ends_at = Time.parse("#{start_date} #{year} #{end_time}")

      note = page.search('.expandableText').text.gsub("\n", "").strip
      @notes = note unless note =~ /tired to say how it went/
    end

    def attributes
      @attributes ||= { :id => nil, :url => nil, :distance => nil, :duration => nil, :average_pace => nil,
                        :average_speed => nil, :calories => nil, :climb => nil, :begins_at => nil, 
                        :ends_at => nil, :notes => nil }
    end

    def to_dailymile
      {
        :message => notes,
        :workout => {
          :distance => { :value => distance, :units => 'kilometers' },
          :activity_type => 'running',
          :completed_at => ends_at,
          :calories => calories,
          :duration => duration
        }
      }
    end

    def to_json(*args)
      to_dailymile.to_json(*args)
    end

    def duration
      ends_at - begins_at
    end
  end
end
