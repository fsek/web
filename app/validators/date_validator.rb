class DateValidator < ActiveModel::EachValidator
  # found at http://andowebsit.es/blog/noteslog.com/post/how-to-validate-dates-in-rails-4/

  attr_accessor :computed_options

  def before(a, b);       a < b;  end
  def after(a, b);        a > b;  end
  def on_or_before(a, b); a <= b; end
  def on_or_after(a, b);  a >= b; end

  def checks
    %w(before after on_or_before on_or_after)
  end

  def message_limits
    needs_and =
        (computed_options[:on_or_after]  || computed_options[:after]) &&
        (computed_options[:on_or_before] || computed_options[:before])

    result = ['must be a date']
    result.push('on or after',  computed_options[:on_or_after])  if computed_options[:on_or_after]
    result.push('after',        computed_options[:after])        if computed_options[:after]
    result.push('and')                                           if needs_and
    result.push('on or before', computed_options[:on_or_before]) if computed_options[:on_or_before]
    result.push('before',       computed_options[:before])       if computed_options[:before]
    result.join(' ')
  end

  def compute_options(record)
    result = {}
    options.each do |key, val|
      print key, val
      next unless checks.include?(key.to_s)
      if val.respond_to?(:lambda?) and val.lambda?
        val = val.call
      elsif val.is_a? Symbol
        if record.respond_to?(val)
          val = record.send(val)
        elsif record.class.respond_to?(val)
          val = record.class.send(val)
        end
      end
      result[key] = val.to_date if !val.blank?
    end
    self.computed_options = result
  end

  def validate_each(record, attribute, value)
    return unless value.present?

    return unless options
    compute_options(record) # do not cache this
                            # otherwise all the 'compute' thing is useless... #
    computed_options.each do |key, val|
      unless self.send(key, value, val)
        record.errors[attribute] << (computed_options[:message] || message_limits)
        return
      end
    end
  end
end
