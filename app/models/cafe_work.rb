# encoding: UTF-8
class CafeWork < ActiveRecord::Base
  # Associations
  belongs_to :user
  has_many :councils, through: :cafe_work_councils
  has_many :cafe_work_councils

  # Validations
  validates :work_day, :pass, :lp, :lv, presence: true
  validates :pass, :lp, inclusion: { in: 1..4 }
  validates :lv, inclusion: { in: 1..20 }
  validates :pass, uniqueness: { scope: [:work_day, :lv, :lp, :d_year] }
  # Worker validations
  validate :user_attributes?, if: :has_worker?

  # Scopes
  scope :with_worker, -> { where.not(user: nil) }
  scope :between, ->(from, to) { where(work_day: from..to) }
  scope :ascending, -> { order(pass: :asc) }
  scope :week, ->(week) { where(lv: week) }
  scope :period, ->(p) { where(lp: p) }
  scope :year, ->(y) { where(d_year: y) }
  scope :all_work_day, -> { order(work_day: :asc) }

  attr_accessor :lv_first, :lv_last
  #  after_update :send_email, if: :has_worker?

  # Sends email to worker
  # /d.wessman
  def send_email
    CafeMailer.sign_up_email(self).deliver_now
  rescue
    Rails.logger.info 'Mailer could not connect, rescued here'
  end

  def old_profile
    if profile_id.present?
      if user_id == nil
        return User.find_by(id: profile_id)
      else
        return user
      end
    else
      return user
    end
  end

  def current_action
    user.present? ? :update_worker : :add_worker
  end

  # Shows different status texts depending on the user.
  # /d.wessman
  def status_text(user)
    case status_view(user)
    when :sign_up
      return I18n.t('cafe_work.status.sign_up')
    when :edit
      return I18n.t('cafe_work.status.signed_up')
    when :assigned
      return I18n.t('cafe_work.status.assigned')
    end
  end

  # Gives different statuses for the view
  # /d.wessman
  def status_view(user)
    if has_worker?
      return owner?(user) ? :edit : :assigned
    end
    :sign_up
  end

  # User to update worker, checks for edit-access and triggers at_update
  # /d.wessman
  def add_worker(worker_params, user)
    if has_worker?
      errors.add(CafeWork.human_attribute_name(:worker), I18n.t('cafe_work.has_worker'))
      return false
    end

    if !editable?
      errors.add(:work_day, I18n.t('cafe_work.no_longer_editable'))
      return false
    end

    # Should be done with a bang when the error handling works
    # Ref: https://github.com/fsek/web/issues/93
    # /d.wessman
    self.user = user
    update(worker_params)
  end

  # User to update worker, checks for edit-access
  # /d.wessman
  def update_worker(worker_params, user)
    if !owner?(user)
      errors.add(I18n.t('authorization'),
                 I18n.t('cafe_work.authorize_failed'))
      return false
    end

    # Should be done with a bang when the error handling works
    # Ref: https://github.com/fsek/web/issues/93
    # /d.wessman
    update!(worker_params)
  end

  # Remove-function used by the worker
  # /d.wessman
  def remove_worker(user)
    if !owner?(user)
      errors.add(I18n.t('authorization'),
                 I18n.t('cafe_work.authorize_failed'))
      return false
    end

    clear_worker
  end

  # Method to remove the worker from current work.
  # /d.wessman
  def clear_worker
    self.user = nil
    self.utskottskamp = false
    councils.clear
    self.save!(validate: false)
  end

  def owner?(user)
    self.user == user
  end

  # Returns true if the user can edit the object
  # /d.wessman
  def edit?(user)
    editable? && (!has_worker? || owner?(user))
  end

  def editable?
    work_day > Time.zone.now
  end

  # Returns true if there is a worker
  # /d.wessman
  def has_worker?
    user.present?
  end

  # Used to print date in a usable format.
  # /d.wessman
  def print_time
    %(#{start.strftime('%H:%M')}-#{stop.strftime('%H:%M')})
  end

  # Used to print out date, reading week and work number
  # /d.wessman
  def print
    %(#{print_date} LV: #{lv} Pass: #{pass})
  end

  def print_date
    %(#{print_time}, #{start.strftime('%A %d/%m')})
  end

  # Prints the url or path for the current object
  def p_url
    Rails.application.routes.url_helpers.cafe_work_url(id, host: PUBLIC_URL)
  end

  def p_path
    Rails.application.routes.url_helpers.cafe_work_path(id)
  end

  def as_json(user, *)
    {
      id: id,
      title: p_title,
      start: start.iso8601,
      end: stop.iso8601,
      status: print,
      url: p_path,
      color: 'black',
      backgroundColor: b_color(user),
      textColor: 'black'
    }
  end

  # To print start time
  def t_start
    start.strftime('%H:%M')
  end

  # To print end time
  def t_end
    stop.strftime('%H:%M')
  end

  def start
    work_day
  end

  # End would be a better name, doesn't fit into code.
  def stop
    work_day + duration.hours
  end

  def self.get_lv
    check = CafeWork.between(Time.zone.now.beginning_of_day - 2.days, Time.zone.now.end_of_day).last
    (check.present?) ? check.lv.to_s : '?'
  end

  protected

  def p_title
    if has_worker?
      %(#{CafeWork.model_name.human} #{pass} - #{user})
    else
      %(#{CafeWork.model_name.human} #{pass})
    end
  end

  # Background color for the event
  def b_color(user)
    if has_worker?
      (user.nil? || owner?(user[:user])) ? 'green' : 'orange'
    else
      'white'
    end
  end

  # Duration of work
  def duration
    ((pass == 1) || (pass == 2)) ? 2 : 3
  end

  def user_attributes?
    if !user.has_attributes?
      errors.add(:user, I18n.t('user.attributes_missing'))
      return false
    end

    true
  end
end
