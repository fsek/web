module CafeHelper
  def cafe_worker_form(shift:, current_user: nil, councils: [])
    if shift.worker?(current_user) || !shift.user.present?
      content_tag(:tr) do
        content_tag(:td, colspan: '2') do
          render('cafe_workers/form', cafe_shift: shift,
                                      councils: councils)
        end
      end
    else
      content_tag(:tr) do
        content_tag(:td, model_name(CafeWorker))
        content_tag(:td, link_to(shift.user, user_path(shift.user)))
      end
    end
  end

  def cafe_worker_shift_error(worker)
    if worker.present? && worker.errors[:cafe_shift].present?
      content_tag(:span, class: 'cafe danger') do
        safe_join([fa_icon('thumbs-o-down'), ' ',
                   I18n.t('cafe_worker.already_working_same_time')])
      end
    end
  end

  def cafe_worker_working_thumbs(worker, user:)
    if user == worker.user && worker.persisted?
      content_tag(:span, class: 'cafe working') do
        safe_join([fa_icon('thumbs-o-up'), ' ',
                   I18n.t('cafe.already_working')])
      end
    end
  end

  def cafe_worker_edit_user(worker)
    if worker.present? && worker.errors[:user].present?
      link_to(I18n.t('user.edit'), edit_own_user_path, class: 'btn danger small',
                                                       target: :blank_p)
    end
  end
end
