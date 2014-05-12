class SessionsMailer < ActionMailer::Base
  layout 'emails'

  def one_time_login(user_id, clear_text_temporary_password)
    @user = User.find(user_id)
    @password = clear_text_temporary_password
    mail(
      subject: t('.subject', app_name: ENV['APP_SHORT_NAME']),
      to: @user.email_with_name
    )
  end

end
