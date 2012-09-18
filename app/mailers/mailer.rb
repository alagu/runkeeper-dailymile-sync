class Mailer < ActionMailer::Base
  def notify(subject, message)
      mail(:to => "alagu@alagu.net", :from => "alagu@alagu.net",
           :subject => subject, :text => message)
  end
end