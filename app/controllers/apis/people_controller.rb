module Apis
  class PeopleController < ApplicationController
    DEFAULT_LIMIT = 5
    DEFAULT_OFFSET = 0

    # Rails_Q1: 名刺を検索できるようにしよう
    def index
      @people = Person.order(id: :desc).limit(DEFAULT_LIMIT).offset(offset_param)
    end

    private

    def query_param
      params[:query]
    end

    def offset_param
      offset = params[:offset].to_i
      offset.positive? ? offset : DEFAULT_OFFSET
    end
  end
end
