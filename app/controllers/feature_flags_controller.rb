class FeatureFlagsController < ApplicationController
  before_action :set_feature_flag, only: [:show, :edit, :update, :destroy]
  before_action :check_permissions

  def index
    @feature_flags = FeatureFlag.all
  end

  def enable
    flagId = params[:flag]
    flag = FeatureFlag.find(flagId)
    flag.value = true
    flag.save

    flash[:success] = "Flag successfully enabled"

    redirect_to feature_flags_path
  end

  def disable
    flagId = params[:flag]
    flag = FeatureFlag.find(flagId)
    flag.value = false
    flag.save

    flash[:success] = "Flag successfully disabled"

    redirect_to feature_flags_path
  end

  def create
    @feature_flag = FeatureFlag.new(feature_flag_params)

    respond_to do |format|
      if @feature_flag.save
        format.html { redirect_to @feature_flag, notice: 'Feature flag was successfully created.' }
        format.json { render :show, status: :created, location: @feature_flag }
      else
        format.html { render :new }
        format.json { render json: @feature_flag.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @feature_flag.destroy
    respond_to do |format|
      format.html { redirect_to feature_flags_url, notice: 'Feature flag was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feature_flag
      @feature_flag = FeatureFlag.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feature_flag_params
      params.require(:feature_flag).permit(:name, :value)
    end

    def check_permissions
      unless current_user.is_admin?
        redirect_to index_path, alert: 'You do not have the permissions to visit the admin page'
      end
    end
end
