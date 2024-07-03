module Apis
  class PersonMemosController < ApplicationController
    before_action :set_person!

    # React_x_Rails_Q4: メモを登録・編集できるようにしよう
    def create
      head :created
    end

    private

    def set_person!
      @person = Person.find(params[:person_id])
    end

    def memo_params
      params.require(:person_memo).permit(:content)
    end
  end
end
