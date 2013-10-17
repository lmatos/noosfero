module RecentContentPluginController

  def index
    block = boxes_holder.blocks.find(params[:block_id])

    articles = block.articles_of_parent(params[:id])
    data = []
    data =  data + get_node(block, articles)
    render :json => data
  end
  
end
