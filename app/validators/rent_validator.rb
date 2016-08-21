class RentValidator < ActiveModel::Validator
  def validate(record)
    if base(record)
      if user_attributes(record)
        record.errors.add(:user, I18n.t('model.rent.validation.add_user_information'))
      end

      if date_future(record)
        record.errors.add(:d_from, I18n.t('model.rent.validation.future'))
      end

      if dates_ascending(record)
        record.errors.add(:d_til, I18n.t('model.rent.validation.ascending'))
      end

      if duration(record)
        record.errors.add(:d_from, I18n.t('model.rent.validation.duration'))
        record.errors.add(:d_til, I18n.t('model.rent.validation.duration'))
      end

      if overlap(record)
        record.errors.add(:d_from, I18n.t('model.rent.validation.overlap'))
      end

      if overlap_council(record)
        record.errors.add(:d_from, I18n.t('model.rent.validation.overlap_council'))
      end

      if overlap_overbook(record)
        record.errors.add(:d_from, I18n.t('model.rent.validation.overlap_overbook'))
      end
    end
  end

  # Checks presence of purpose, user and dates.
  # When necessary - based on defined actions.
  def base(record)
    state = true
    if !user(record)
      record.errors.add(:user, :blank)
      state = false
    end

    if !d_from(record)
      record.errors.add(:d_from, :blank)
      state = false
    end

    if !d_til(record)
      record.errors.add(:d_til, :blank)
      state = false
    end

    if !purpose(record)
      record.errors.add(:purpose, :blank)
      state = false
    end

    state
  end

  private

  def user(record)
    record.user.present?
  end

  def d_from(record)
    record.d_from.present?
  end

  def d_til(record)
    record.d_til.present?
  end

  def purpose(record)
    record.purpose.present?
  end

  # Validations assume that d_from, d_til and user is present.

  def user_attributes(record)
    !record.user.try(:has_attributes?)
  end

  def date_future(record)
    record.d_from < Time.zone.now
  end

  def dates_ascending(record)
    record.d_from > record.d_til
  end

  def duration(record)
    record.duration > 48 && !record.has_council?
  end

  def overlap(record)
    !record.has_council? && !record.overlap.empty?
  end

  def overlap_council(record)
    record.council.present? && record.overlap.present? && !record.overlap.councils.empty?
  end

  def overlap_overbook(record)
    record.has_council? && record.overlap.present? &&
      (overlap = record.overlap.ascending.first).present? &&
      overlap.d_from < Time.zone.now + 5.days
  end
end
