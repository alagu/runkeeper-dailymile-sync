require 'machinist/active_record'

Activity.blueprint do
  user
  content { { :one => 'thing' } }
  success { true }
end

User.blueprint do
  provider { 'dailymile' }
  dailymile_id { 'dm_user' }
  runkeeper_id { 'rk_user' }
  name { "Joey User #{sn}" }
  last_activity_id { 23413432 }
end
