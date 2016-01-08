#encoding:utf-8
class UsersController < ApplicationController
  wrap_parameters :user, include: [:email, :nickname, :password, :password_confirmation]

  def login
    
  end

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @posts = Post.find_by_sql('select * from Posts where user_id = ' + @user.id.to_s)
    @likes = Like.find_by_sql("select * from Likes where user_id = " + @user.id.to_s)
    #debugger
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    #@user = current_user
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html do
          log_in @user
          flash[:success] = "欢迎来到国科大跳蚤市场！"
          redirect_to @user
        end
        format.json { render json: @user.to_json }
      else
        format.html { render 'new' }
        format.json { render json: @user.errors }

      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
      @user = User.find params[:id]

      @user.update_attribute(:nickname, user_params_edit[:nickname])
      @user.update_attribute(:phoneNum, user_params_edit[:phoneNum])
      @user.update_attribute(:address, user_params_edit[:address])

      redirect_to @user, notice: '保存成功！'
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :nickname, :password, :password_confirmation)
    end
    def user_params_edit
      params.require(:user).permit(:nickname, :phoneNum, :address)
    end
end
