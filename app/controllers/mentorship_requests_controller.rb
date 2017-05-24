class MentorshipRequestsController < ApplicationController
  before_action :set_mentorship_request, only: [:show, :edit, :update, :destroy]

  # GET /mentorship_requests
  # GET /mentorship_requests.json
  def index
    @mentorship_requests = MentorshipRequest.all
  end

  # GET /mentorship_requests/1
  # GET /mentorship_requests/1.json
  def show
  end

  # GET /mentorship_requests/new
  def new
    @mentorship_request = MentorshipRequest.new
  end

  # GET /mentorship_requests/1/edit
  def edit
  end

  # POST /mentorship_requests
  # POST /mentorship_requests.json
  def create
    @mentorship_request = MentorshipRequest.new(mentorship_request_params)
    @mentorship_request.user_id = mentorship_request.user_id
    
    respond_to do |format|
      if @mentorship_request.save
        format.html { redirect_to @mentorship_request, notice: 'Mentorship request was successfully created.' }
        format.json { render :show, status: :created, location: @mentorship_request }
      else
        format.html { render :new }
        format.json { render json: @mentorship_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mentorship_requests/1
  # PATCH/PUT /mentorship_requests/1.json
  def update
    respond_to do |format|
      if @mentorship_request.update(mentorship_request_params)
        format.html { redirect_to @mentorship_request, notice: 'Mentorship request was successfully updated.' }
        format.json { render :show, status: :ok, location: @mentorship_request }
      else
        format.html { render :edit }
        format.json { render json: @mentorship_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mentorship_requests/1
  # DELETE /mentorship_requests/1.json
  def destroy
    @mentorship_request.destroy
    respond_to do |format|
      format.html { redirect_to mentorship_requests_url, notice: 'Mentorship request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mentorship_request
      @mentorship_request = MentorshipRequest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mentorship_request_params
      params.require(:mentorship_request).permit(:user_id, :mentor_id, :title, :type, :status)
    end
end
