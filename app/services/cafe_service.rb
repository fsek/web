# encoding: UTF-8
module CafeService
  def self.setup(start, stop, day, lp)
    CafeShift.create!(preview(start, stop, day, lp))
  end

  def self.preview(start, stop, day, lp)
    shifts = []
    (start..stop).each do |lv|
      (0..4).each do
        shifts << { start: day, lp: lp, pass: 1, lv: lv }
        shifts << { start: day, lp: lp, pass: 2, lv: lv }
        shifts << { start: day + 2.hours, lp: lp, pass: 3, lv: lv }
        shifts << { start: day + 2.hours, lp: lp, pass: 4, lv: lv }
        day += 1.days
      end
      day += 2.days
    end
    shifts
  end

  def self.create_worker(shift, param)
    shift.build_cafe_worker(param)

    if shift.cafe_worker.save!
      cafe_worker_groups(shift, param)
      true
    else
      false
    end
  end

  private

  def self.cafe_worker_groups(shift, param)
    CafeWorkerCouncil.transaction do
      if param[:council_ids].present?
        param[:council_ids].each do |id|
          CafeWorkerCouncil.new(cafe_worker: shift.cafe_worker, council_id: id).save! if id.present?
        end
      end
    end
  end
end
