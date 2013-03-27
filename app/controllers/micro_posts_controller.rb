class MicroPostsController < ApplicationController
  # GET /micro_posts
  # GET /micro_posts.json
  before_filter :redirect_unless_authorized, only: [:edit, :update, :destroy]
  
  
  def index
    @micro_posts = MicroPost.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @micro_posts }
    end
  end

  # GET /micro_posts/1
  # GET /micro_posts/1.json
  def show
    @micro_post = MicroPost.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @micro_post }
    end
  end

  # GET /micro_posts/new
  # GET /micro_posts/new.json
  def new
    @micro_post = MicroPost.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @micro_post }
    end
  end

  # GET /micro_posts/1/edit
  def edit
    @micro_post = MicroPost.find(params[:id])
  end

  # POST /micro_posts
  # POST /micro_posts.json
  def create
	@micro_post = current_user.micro_posts.build(params[:micro_post])

    respond_to do |format|
      if @micro_post.save
        format.html { redirect_to @micro_post, notice: 'Micro post was successfully created.' }
        format.json { render json: @micro_post, status: :created, location: @micro_post }
		format.js {render partial: 'micro_posts/show'}
      else
        format.html { render action: "new" }
        format.json { render json: @micro_post.errors, status: :unprocessable_entity }
		format.js {render partial: 'micro_posts/errors'}
      end
    end
  end

  # PUT /micro_posts/1
  # PUT /micro_posts/1.json
  def update
    @micro_post = MicroPost.find(params[:id])

    respond_to do |format|
      if @micro_post.update_attributes(params[:micro_post])
        format.html { redirect_to @micro_post, notice: 'Micro post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @micro_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /micro_posts/1
  # DELETE /micro_posts/1.json
  def destroy
    @micro_post = MicroPost.find(params[:id])
    @micro_post.destroy

    respond_to do |format|
      format.html { redirect_to micro_posts_url }
      format.json { head :no_content }
	  format.js { render partial: 'micro_posts/destroy' }
    end
  end
  
  # GET /micro_posts/refresh?ids=[1,2,3,4,5] 
  def refresh
   feed = current_user.feed(page: 1)
   @new_micro_posts = feed.reject { |p| params[:ids].include?(p.id.to_s) }
   respond_to do |format|
   format.js
   end
  end
  
  private
  
  def redirect_unless_authorized
    @mp = MicroPost.find(params[:id])
    @user=@mp.user
    
    unless signed_in? && current_user==@user
      redirect_to root_path
      flash[:error] = "You are not authorized to edit that MicroPost"
    end

  end
  
end
