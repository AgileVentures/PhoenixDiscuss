require IEx;

defmodule Discuss.CommentsChannel do
  use Discuss.Web, :channel
  alias Discuss.{Topic, Comment}
  
  def join("comments:" <> topic_id, _params, socket) do
    topic_id = String.to_integer(topic_id)
    topic = Repo.get(Topic, topic_id)
    
    {:ok, %{}, assign(socket, :topic, topic)}
  end
  
  def handle_in(name, %{"body" => content}, socket) do
    # IO.puts "topic:!!!!!!!!!!!!!!!!!!!"
   
    # IEx.pry
    
    topic = socket.assigns.topic
    # IO.inspect topic

    changeset = topic |> build_assoc(:comments) |> Comment.changeset(%{body: content})
      
    response = "<li class=\"collection-item\">#{content}</li>"  
    case Repo.insert(changeset) do
      {:ok, comment} ->
        broadcast!(socket, "live_response", %{html: response})
        {:noreply, socket}
        # {:reply, :ok, socket}
      {:error, _reason} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
    
    
  
  end
  
end