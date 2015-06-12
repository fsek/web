class RentValidator
  def initialize(rent)
    @rent = rent
  end

  def validate
    user_attributes
    date_future
    dates_ascending
    duration
    overlap
    overlap_council
    overlap_overbook
  end

  private

  def user_attributes
    if !@rent.user.try(:has_attributes?)
      @rent.errors.add(:user, I18n.t('user.add_information'))
    end
  end

  # Validates d_from is in the future
  def date_future
    if @rent.d_from.present? && @rent.d_til.present? &&
      @rent.d_from < Time.zone.now
      @rent.errors.add(:d_from, I18n.t('rent.validation.future'))
    end
  end

  # Validates d_from is before d_til
  def dates_ascending
    if @rent.d_from.present? && @rent.d_til.present? &&
      @rent.d_from > @rent.d_til
      @rent.errors.add(:d_til, I18n.t('rent.validation.ascending'))
    end
  end

  # To validate the length of the renting
  # /d.wessman
  def duration
    if @rent.duration > 48 && @rent.council.nil?
      @rent.errors.add(:d_from, I18n.t('rent.validation.duration'))
      @rent.errors.add(:d_til, I18n.t('rent.validation.duration'))
    end
  end

  # Custom validations
  def overlap
    if @rent.council.nil? && @rent.overlap.present? && @rent.overlap.count > 0
      @rent.errors.add(:d_from, I18n.t('rent.validation.overlap'))
    end
  end

  def overlap_council
    if @rent.council.present? && @rent.overlap.present? &&
      @rent.overlap.councils.count > 0
      @rent.errors.add(:d_from, I18n.t('rent.validation.overlap_council'))
    end
  end

  def overlap_overbook
    if @rent.council.present? && @rent.overlap.present? &&
      (overlap = @rent.overlap.ascending.first).present? &&
      overlap.d_from < Time.zone.now + 5.days
      @rent.errors.add(:d_from, I18n.t('rent.validation.overlap_overbook'))
    end
  end
end
