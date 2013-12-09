class JobOffersController < ApplicationController
  include UsersHelper

  before_filter :check_user_is_responsible, only: [:edit, :update]
  before_filter :check_user_is_research_assistant, only: [:complete]
  before_action :set_job_offer, only: [:show, :edit, :update, :destroy, :complete]
  before_action :set_chairs, only: [:index, :find_jobs, :archive]

  # GET /job_offers
  # GET /job_offers.json
  def index
    @radio_button_sort_value = {"date" => false, "chair" => false}
    @job_offers = JobOffer.order("created_at")
    @job_offers = @job_offers.paginate(:page => params[:page])
  end

  # GET /job_offers/1
  # GET /job_offers/1.json
  def show

  end

  # GET /job_offers/new
  def new
    @job_offer = JobOffer.new
    @programming_languages = ProgrammingLanguage.all
    @languages = Language.all
  end

  # GET /job_offers/1/edit
  def edit
    @programming_languages = ProgrammingLanguage.all
    @languages = Language.all
  end

  # POST /job_offers
  # POST /job_offers.json
  def create
    @job_offer = JobOffer.new(job_offer_params)
    @job_offer.status = JobStatus.where(name: "pending").first
    @job_offer.responsible_user = current_user
    respond_to do |format|
      if @job_offer.save
        JobOffersMailer.new_job_offer_email(@job_offer).deliver
        format.html { redirect_to @job_offer, notice: 'Job offer was successfully created.' }
        format.json { render action: 'show', status: :created, location: @job_offer }
      else
        render_errors_and_redirect_to(@job_offer, 'new', format)
      end
    end

  end

  # PATCH/PUT /job_offers/1
  # PATCH/PUT /job_offers/1.json
  def update
    respond_to do |format|
      if @job_offer.update(job_offer_params)
        format.html { redirect_to @job_offer, notice: 'Job offer was successfully updated.' }
        format.json { head :no_content }
      else
        render_errors_and_redirect_to(@job_offer, 'edit', format)
      end
    end
  end

  # DELETE /job_offers/1
  # DELETE /job_offers/1.json
  def destroy
    @job_offer.destroy
    respond_to do |format|
      format.html { redirect_to job_offers_url }
      format.json { head :no_content }
    end
  end

  # GET /job_offers/archive
  def archive
    @job_offers = JobOffer.where(:status_id => JobStatus.where( :name=>"completed" ).first)
    @radio_button_sort_value = {"date" => false, "chair" => false}
    @job_offers = @job_offers.paginate(:page => params[:page])
  end

  # GET /job_offers/sort
  def sort
     @radio_button_sort_value = {"date" => false, "chair" => false}
     sort_value =  params.require(:sort_value)
     logger.warn(sort_value)
     @radio_button_sort_value[sort_value] = true
     logger.warn(@radio_button_sort_value)

     @job_offers = JobOffer.sort sort_value
     render "index"
  end


  # GET /job_offers/search
  def search
    @radio_button_sort_value = {"date" => false, "chair" => false}
    @job_offers = JobOffer.search params[:search]

    render "index"
  end

  # GET /job_offers/filter
  def filter
    @radio_button_sort_value = {"date" => false, "chair" => false}

    @job_offers = JobOffer.filter({
                                    :chair => params[:chair], 
                                    :start_date => params[:start_date],
                                    :end_date => params[:end_date],
                                    :time_effort => params[:time_effort],
                                    :compensation => params[:compensation]})

     render "index"
  end

  def find

    @radio_button_sort_value = {"date" => false, "chair" => false}

    @job_offers = JobOffer.find_jobs({
      search:  params[:search],
      sort: params[:sort],
      filter: {
                :chair => params[:chair], 
                :start_date => params[:start_date],
                :end_date => params[:end_date],
                :time_effort => params[:time_effort],
                :compensation => params[:compensation]}

    }) 
    
    @job_offers = @job_offers.paginate(:page => params[:page])
    render "index"


  end

  # GET /job_offers/complete
  def complete
    respond_to do |format|
      if @job_offer.update(:status => JobStatus.where( :name=>"completed" ).first )
        format.html { redirect_to @job_offer, notice: 'Job offer was successfully marked as completed.' }
        format.json { head :no_content }
      else
        render_errors_and_redirect_to(@job_offer, 'edit', format)
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job_offer
      @job_offer = JobOffer.find params[:id]
    end

    def set_chairs
      @chairs = Chair.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_offer_params
      params.require(:job_offer).permit(:description, :title, :chair_id, :room_number, :start_date, :end_date, :compensation, :time_effort, {:programming_language_ids => []},
        {:language_ids => []})
    end
    
    def render_errors_and_redirect_to(object, target, format)
      format.html { render action: target }
      format.json { render json: object.errors, status: :unprocessable_entity }
    end  

    def check_user_is_responsible
      @job_offer = JobOffer.find params[:id]

      unless current_user == @job_offer.responsible_user
        redirect_to @job_offer
      end
    end

    def check_user_is_research_assistant
      @job_offer = JobOffer.find params[:id]

      unless user_is_research_assistant_of_chair?(@job_offer)
        redirect_to @job_offer
      end
    end
end
