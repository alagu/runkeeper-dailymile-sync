class Activity < ActiveRecord::Base
  paginates_per 50
  belongs_to :user
  serialize :content
  serialize :response
end
