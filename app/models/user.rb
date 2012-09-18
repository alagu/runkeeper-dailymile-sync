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
    mail(:to => 'alagu@alagu.net', :from => 'alagu@alagu.net', :subject => subject, :text => message)
  end
end
