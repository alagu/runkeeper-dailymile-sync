class Activity < ActiveRecord::Base
  belongs_to :user
  serialize :content
  serialize :response
end
