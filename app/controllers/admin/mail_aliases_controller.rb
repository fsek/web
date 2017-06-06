class Admin::MailAliasesController < Admin::BaseController
  load_permissions_and_authorize_resource

  def index
  end

  def search
    if params[:q]
      @aliases = MailAlias.fulltext_search(params[:q])
    else
      @aliases = MailAlias.none
    end

    render :json => { :mail_aliases => process_list(@aliases) }
  end

  def update
    begin
      # If targets is [] it will become nil over HTTP so handle it here.
      @aliases = MailAlias.insert_aliases! mail_alias_params[:username],
                                           mail_alias_params[:domain],
                                           mail_alias_params[:targets] || []
    rescue ActiveRecord::RecordInvalid => ex
      render :nothing => true, :status => :unprocessable_entity
      return
    end

    render :json => { :mail_aliases => process_list(@aliases) }
  end

  private
  def mail_alias_params
    params.require(:mail_alias).permit(
      [ :username, :domain, :targets => []]
    )
  end

  def process_list lst
    # Do the processing here in ruby where we have functioning hashmaps etc.
    table = lst.group_by(&:address)
    return table.keys.sort.map do |k|
      { :username => table[k].first.username,
        :domain => table[k].first.domain,
        :targets => table[k].map(&:target).sort }
    end
  end
end
