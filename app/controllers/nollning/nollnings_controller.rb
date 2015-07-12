# encoding: UTF-8
class Nollning::NollningsController < ApplicationController
  # load_permissions_and_authorize_resource Album

  def index
    @page = Page.find_by(namespace: :nollning, title: 'Startsida')
  end

  def matrix
  end
end
