class PostsController < ApplicationController

  before_action :authenticate_user!, expect: %i(index)
  before_action :set_post, only: %i(edit update show destroy)
  
  def index
    @posts = Post.limit(10).includes(:photos, :user).order('created_at DESC')
  end

  def new
    @post = Post.new
    @post.photos.build
    @food = @post.foods.build
  end

  def create
    @post = Post.new(post_params)
    if @post.photos.present?
      @post.save
      redirect_to root_path
      #flash[:notice] = "投稿が保存されました"
    else
      redirect_to root_path
      #flash[:alert] = "投稿に失敗しました"
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to post_path
      #flash[:notice] = "投稿が保存されました"
    else
      render :edit
      #flash[:alert] = "投稿に失敗しました"
    end
  end

  def show
    @posts = Post.limit(10).includes(:photos, :user).order('created_at DESC')
    @food = Food.find_by(id: params[:id])
  end

  def destroy
    if @post.user == current_user
      @post.destroy
      #flash[:notice] = "投稿が削除されました" if @post.destroy
    else
      #flash[:alert] = "投稿の削除に失敗しました"
    end
    redirect_to root_path
  end

  def hashtag
    @user = current_user
    @tag =  Hashtag.find_by(hashname: params[:name])
    @posts = @tag.posts
  end

  private
    def post_params
      params.require(:post).permit(:caption, photos_attributes: [:id, :image], foods_attributes: [:id, :ingredient, :quantity, :_destroy]).merge(user_id: current_user.id)
    end

    def set_post
      @post = Post.find_by(id: params[:id])
    end
end
