class NotificationMailer < ApplicationMailer
  default from: 'F-sektionen <notifikation@fsektionen.se>'
  helper :notification, :application, :markdown

  def notify(notification)
    @notification = notification
    subject = I18n.t('notification_mailer.subject', notification: notification.to_s)

    mail(subject: subject, to: notification.user.print_email)
  end
end
