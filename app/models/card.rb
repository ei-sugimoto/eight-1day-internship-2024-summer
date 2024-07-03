# == Schema Information
#
# Table name: cards
#
#  id           :bigint           not null, primary key
#  department   :string(255)
#  email        :string(255)
#  name         :string(255)
#  organization :string(255)
#  title        :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  person_id    :bigint           not null
#
# Indexes
#
#  index_cards_on_email         (email)
#  index_cards_on_name          (name)
#  index_cards_on_organization  (organization)
#  index_cards_on_person_id     (person_id)
#
# Foreign Keys
#
#  fk_rails_...  (person_id => people.id)
#
class Card < ApplicationRecord
  include CalculationTitleScore

  belongs_to :person

  # Rails_Q2: 人脈管理をしよう
  def register; end
end
