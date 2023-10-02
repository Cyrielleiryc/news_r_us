class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]
  skip_before_action :authenticate_user!, only: %i[index]
  skip_after_action :verify_authorized, only: %i[show new create]

  def index
    if params[:query].present?
      @posts = Post.search_by_title_and_content(params[:query])
    else
      @posts = Post.all
    end
    skip_policy_scope
  end

  def show
    @comments = @post.comments.order(:created_at).reverse
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if @post.save!
      redirect_to post_path(@post), notice: "Votre article a été publié avec succès"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def my_posts
    @posts = Post.where(user: current_user).order(:created_at).reverse
    authorize @posts, policy_class: PostPolicy
  end

  def edit
    authorize @post
  end

  def update
    authorize @post
    @post.update(post_params)
    if @post.save
      redirect_to post_path(@post)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @post
    @post.destroy
    redirect_to my_posts_path, status: :see_other
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :url, :photo)
  end
end
