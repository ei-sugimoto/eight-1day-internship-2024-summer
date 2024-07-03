module Apis
  class CardsController < ApplicationController
    include S3Usable

    def image
      send_data(s3_resource.bucket('cards').object(params[:id]).get.body.read, type: Mime[:jpeg], disposition: 'inline')
    end
  end
end
