class Runkeeper
  class Activity
    include ActiveModel::Serializers::JSON

    attr_accessor :id, :url, :distance, :duration, :average_pace, :average_speed,
      :calories, :climb, :begins_at, :ends_at, :notes

    def initialize(page)
      @id = page.search('div.activityMonth.selected')[0][:link].split('/').last
      @distance = page.search('div#statsDistance div.mainText').first.children.text
      @duration = page.search('div#statsDuration div.mainText').first.children.text
      @average_pace = page.search('div#statsPace div.mainText').first.children.text
      @average_speed = page.search('div#statsSpeed div.mainText').first.children.text
      @calories = page.search('div#statsCalories div.mainText').first.children.text
      @climb = page.search('div#statsElevation div.mainText').first.children.text

      date = page.search('div#activityDateText').first.text
      start_date, times = date.split('::')
      start_time, end_time = times.split('-')

      @begins_at = Time.parse("#{start_date} #{start_time}")
      @ends_at = Time.parse("#{start_date} #{end_time}")

      note = page.search('div#notes p').first.children.text.strip
      @notes = note unless note =~ /not entered/
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
          :distance => { :value => distance, :units => 'miles' },
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
