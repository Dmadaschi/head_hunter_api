class V1::OpportunitiesController < ApplicationController
  before_action :authenticate_head_hunter!, only: [:create]
  def create
    if Opportunitie.new(opportunitie_params).save!
      render :json, status: :created
    end
  end

  private

  def opportunitie_params
    params.require(:opportunitie)
          .permit(:title, :hirer, :description,
                  :requirements, :location)
          .merge(head_hunter_id: current_head_hunter.id)
  end
end
