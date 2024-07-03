# == Schema Information
#
# Table name: people
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Person < ApplicationRecord
  has_many :cards, dependent: :destroy
  has_one  :memo, dependent: :destroy, class_name: 'PersonMemo'
end
