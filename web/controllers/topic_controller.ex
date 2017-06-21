defmodule Discuss.TopicController do
  use Discuss.Web, :controller
  
  alias Discuss.Topic

  def index(conn, _params) do
    # IO.inspect get_session(conn, :user_id)
    render conn, "index.html", topics: Repo.all(Topic)
  end
  
  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})
    
    render conn, "new.html", changeset: changeset
  end
  
  def create(conn, %{"topic" => topic}) do
    changeset = Topic.changeset(%Topic{}, topic)
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
end 