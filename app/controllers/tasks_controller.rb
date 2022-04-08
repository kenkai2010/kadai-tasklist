class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:show, :edit, :update, :destroy]
  
  def index
    @pagy, @tasks = pagy(Task.where(user_id: current_user.id).includes(:user).order("created_at DESC"))
  end

  def show
  end

  def new
    @tasklist = Task.new
  end

  def create
    @tasklist = current_user.tasks.build(task_params)

    if @tasklist.save
      flash[:success] = 'Task が正常に投稿されました'
      redirect_to root_url
    else
      flash.now[:danger] = 'Task が投稿されませんでした'
      render :new
    end
  end

  def edit
  end

  def update
    if @tasklist.update(task_params)
      flash[:success] = 'Task は正常に更新されました'
      redirect_to @tasklist
    else
      flash.now[:danger] = 'Task は更新されませんでした'
      render :edit
    end
  end

  def destroy
    @tasklist.destroy

    flash[:success] = 'Task は正常に削除されました'
    redirect_to tasks_url
  end
  
  private
  
  # Strong Parameter
  def task_params
    params.require(:task).permit(:status, :content)
  end
  
  def correct_user
    @tasklist = current_user.tasks.find_by(id: params[:id])
    unless @tasklist
      redirect_to root_url
    end
  end
end
