class Mailer < ActionMailer::Base
  def notify(subject, message)
    puts "Sending #{subject} #{message}"
    
    mail(:to      => "alagu@alagu.net", 
         :from    => "alagu@alagu.net",
         :subject => subject) do |format|
      format.text { render :text => message }
    end
  end
end