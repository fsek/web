# encoding: utf-8
class Role < ActiveRecord::Base
  has_many :users
end
