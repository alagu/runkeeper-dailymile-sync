require 'rest_client'

class User < ActiveRecord::Base
  has_many :activities

  validates_presence_of :dailymile_id
  validates_uniqueness_of :dailymile_id

  scope :active, where("state = 'active' and runkeeper_id is not null")
  scope :public, where(:rk_private => false)

  state_machine :initial => :active do
    state :active
    state :suspended

    event :suspend do
      transition :active => :suspended
    end
  end

  def self.create_with_omniauth(auth)  
    create! do |user|  
      user.access_token = auth["credentials"]["token"]
      user.provider = auth["provider"]  
      user.dailymile_id = auth["uid"]  
      user.name = auth["user_info"]["name"]  
    end  
  end 

  def email(subject, message)
    API_KEY = ENV['MAILGUN_API_KEY']
    API_URL = "https://api:#{API_KEY}@api.mailgun.net/v2/mailgun.net"

    RestClient.post API_URL+"/messages", 
        :from => "alagu@alagu.net",
        :to => "alagu@alagu.net",
        :subject => subject,
        :text => message
  end
end
