class FeatureFlagsController < ApplicationController
  before_action :set_feature_flag, only: [:show, :edit, :update, :destroy]
  before_action :check_permissions

  def index
    @feature_flags = FeatureFlag.all
  end

  def enable
    flag_id = params[:flag]
    flag = FeatureFlag.find(flag_id)
    # Enable the feature flag and update in database
    flag.value = true
    flag.save

    # Tell user flag is enabled, and format name nicely
    flash[:success] = "Flag Enabled: " + flag.display_name

    redirect_to feature_flags_path
  end

  def disable
    flag_id = params[:flag]
    flag = FeatureFlag.find(flag_id)
    # Disable the feature flag and update in database
    flag.value = false
    flag.save

    flash[:success] = "Flag Disabled: " + flag.display_name

    redirect_to feature_flags_path
  end

  def create
    @feature_flag = FeatureFlag.new(feature_flag_params)

    respond_to do |format|
      if @feature_flag.save
        # If successful in creating the new feature flag
        format.html { redirect_to @feature_flag, notice: 'Feature flag successfully created.' }
        format.json { render :show, status: :created, location: @feature_flag }
      else
        # If there was an error creating the new feature flag
        format.html { render :new }
        format.json { render json: @feature_flag.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @feature_flag.destroy
    respond_to do |format|
      # Permanently remove flag
      format.html { redirect_to feature_flags_url, notice: 'Feature flag successfully destroyed.'}
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feature_flag
      @feature_flag = FeatureFlag.find(params[:id])
    end

    # Check parameters to ensure only whitelisted ones are able to be passed through.
    def feature_flag_params
      params.require(:feature_flag).permit(:name, :value, :description)
    end

    def check_permissions
      unless current_user.is_admin?
        redirect_to index_path, alert: 'You do not have the permissions to visit the admin page'
      end
    end
end
