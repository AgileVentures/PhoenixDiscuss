defmodule Discuss.TopicController do
  use Discuss.Web, :controller
  
  alias Discuss.Topic
  
  plug Discuss.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]
  plug :check_topic_owner when action in [:update, :edit, :delete]

  def index(conn, _params) do
    IO.inspect conn
    render conn, "index.html", topics: Repo.all(Topic) 
  end
  
  def show(conn, %{"id" => topic_id}) do
    topic = Repo.get(Topic, topic_id)
    comments = Repo.all assoc(topic, :comments)
    render conn, "show.html", topic: topic, comments: comments
  end
  
  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})
    
    render conn, "new.html", changeset: changeset
  end
  
  def create(conn, %{"topic" => topic}) do
    # changeset = %Topic{}
    #   |> Topic.changeset(topic)
      
    # assoc = build_assoc(conn.assigns.user, :topics)
    # changeset = Topic.changeset(assoc, topic)
    
    changeset = conn.assigns.user
      |> build_assoc(:topics)
      |> Topic.changeset(topic)
    
    case Repo.insert(changeset) do
      {:ok, _struct}      -> 
        conn  
        |> put_flash(:info, "Your topic has been saved!")
        |> redirect to: topic_path(conn, :index)
      {:error, changeset} -> render conn, "new.html", changeset: changeset
    end
  end

  def edit(conn, %{"id" => topic_id}) do
    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)
    render conn, "edit.html", changeset: changeset, topic: topic
  end
  
  def update(conn, params = %{"id" => topic_id, "topic" => topic}) do
    old_topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(old_topic, topic)
    IO.inspect changeset
    Repo.update(changeset)
    
    redirect conn, to: topic_path(conn, :index)
  end
  
  def delete(conn, %{"id" => topic_id}) do
    topic = Repo.get!(Topic, topic_id)
    Repo.delete!(topic)
    
    conn = put_flash(conn, :info, "Your bad topic was deleted")
    redirect(conn, to: topic_path(conn, :index))
  end
  
  defp check_topic_owner(conn, _params) do
    %{params: %{"id" => topic_id}} = conn
    
    if Repo.get(Topic, topic_id).user_id == conn.assigns.user.id do
      conn
    else
      conn
      |> put_flash(:error, "You cannot edit that")
      |> redirect(to: topic_path(conn, :index))
      |> halt()
    end
  end
end 