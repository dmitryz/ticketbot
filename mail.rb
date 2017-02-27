require 'mail'
require 'fileutils'

options = { address: 'smtp.gmail.com',
            port: 587,
            user_name: ENV['TICKETBOT_SMTP_LOGIN'],
            password: ENV['TICKETBOT_SMTP_PASSW'],
            authentication: 'plain',
            enable_starttls_auto: true }

Mail.defaults do
    delivery_method :smtp, options
end

def mail_notify(arg_subject, arg_body, label)
  lock_path = File.dirname(__FILE__) + "/tmp/#{label}"
  seconds_ago = File.exists?(lock_path) ? Time.now - File.mtime(lock_path) : 360000
  return if seconds_ago < 3600
  puts "Notify"
  FileUtils.touch(lock_path)
  Mail.deliver do
    to ENV['TICKETBOT_EMAIL']
    from ENV['TICKETBOT_EMAIL']
    subject arg_subject
    body arg_body
  end
end
