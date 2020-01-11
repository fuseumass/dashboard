class JudgingController < ApplicationController

  def index
    @scores = ProjectScore.all
  end


  def show
  end


  def new
    @score = ProjectScore.new
  end


  def edit
  end


  def create
    @score = ProjectScore.new(judging_params)
  end

  def update
    if @score.update(judging_params)
        redirect_to @score, notice: 'Project Rating Successfully Updated.'
    else
      render :edit
    end
  end

  def destroy
    @score.destroy
      redirect_to judging_url, notice: 'Project Rating Successfully Deleted.'
  end

end
