class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]

  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1 or /posts/1.json
  def show
    @post.increment!(:views)
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    # If there is a draft, load it into the @post model
    post_draft = PostDraft.find_by(id: params[:id])

    # If @post is a draft, load the draft into the @post model by replacing
    # fields with draft fields
    return unless post_draft

    puts 'Loading draft into post'
    puts "Draft title: #{post_draft.title}"
    puts "Draft body: #{post_draft.body}"

    @post.title = post_draft.title
    @post.body = post_draft.body
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to post_url(@post), notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def autosave
    post_draft = PostDraft.find_or_initialize_by(id: params[:id])
    post_draft.assign_attributes(post_params)
    post_draft.save

    flash.now[:notice] = 'Draft saved successfully!'

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream:
          turbo_stream.replace('flash', partial: 'layouts/flash')
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:title, :body)
  end
end
