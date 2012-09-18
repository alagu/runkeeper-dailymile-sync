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
    api_key = ENV['MAILGUN_API_KEY']
    api_url = "https://api:#{api_key}@api.mailgun.net/v2/mailgun.net"

    RestClient.post api_url + "/messages", 
        :from => "alagu@alagu.net",
        :to => "alagu@alagu.net",
        :subject => subject,
        :text => message,
        :html => message
  end
end
