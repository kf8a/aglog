# encoding: UTF-8
# Allows modification and viewing of observations
class ObservationsController < ApplicationController
  ActionController::Parameters.action_on_unpermitted_parameters = :raise

  # helper_method :observation
  respond_to :json, :html

  # GET /observations
  # GET /observations.xml
  def index
    obstype = ObservationType.find(params[:obstype])
    if obstype
      @observations = obstype.observations
    elsif params[:query]
      @observations =
        Observation.ordered_by_date
                   .basic_search(comment: params[:query])
      @query = params[:query]
    else
      @observations = Observation.all
    end
    if params[:year]
      @observations = @observations.by_year(params[:year].to_i)
      @year = params[:year]
    end

    # @observations = @observations.by_obstype(obstype)
    @observations = @observations.by_company(current_user.company) if signed_in?
    @observations = @observations.by_page(params[:page])

    respond_with @observations do |format|
      format.salus_xml { render 'index', formats: [:salus_xml] }
      format.salus_csv { render 'index', formats: [:salus_csv] }
    end
  end

  def show
    @observation = Observation.where(id: params[:id])
                              .includes(:person, :observation_types, activities:
                                        [:person, { setups:
                                          [:equipment,
                                           { material_transactions:
                                             [:material, :unit] }] }]).first
    @areas_as_text = @observation.areas_as_text
    respond_with @observation
  end

  def new
    @observation = Observation.new
    @observation.obs_date = Time.zone.today
    respond_with @observation
  end

  # POST /observations
  # POST /observations.xml
  def create
    user = current_user.person
    @observation = user.observations.new(observation_params)
    @observation.company = user.company
    logger.info user.name
    flash[:form] = @observation.save ? 'Observation was successfully created.' : 'Observation creation failed'
    respond_with @observation
  end

  def edit
    @observation = Observation.by_company(current_user.company)
                              .where(id: params[:id])
                              .includes(:observation_types,
                                        activities:
                                        { setups: :material_transactions })
                              .first
    respond_with @observation
  end

  def update
    @observation = Observation.where(id: params[:id])
                              .includes(:observation_types,
                                        activities:
                                        { setups: :material_transactions })
                              .first
    if @observation.update_attributes(observation_params) && @observation.save
      flash[:notice] = 'Observation was successfully updated.'
    end
    respond_with @observation
  end

  def destroy
    @observation = Observation.find(params[:id])
    @observation.destroy
    redirect_to observations_url
  end

  def related
    @observation = Observation.where(id: params[:id])
                              .includes(areas: :observations).first
  end

  # def observation
  #   Observation.find(params[:id])
  # end

  private

  def observation_params
    params.require(:observation)
          .permit(:observation_date, :comment, { observation_type_ids: [] },
                  :areas_as_text, { notes: [] }, :notes_cache,
                  activities_attributes:
                  [{ person: :id }, :person_id, :hours,
                   :id, :_destroy,
                   { setups_attributes:
                     [{ equipment: [:id] }, :equipment_id, :id, :_destroy,
                      { material_transactions_attributes:
                       [:id, :material_id, { material: :id }, :rate,
                        { unit: :id }, :unit_id, :_destroy] }] }])
  end
end
