

defmodule Discuss.AuthController do
  use Discuss.Web, :controller
  plug Ueberauth
  
  alias Discuss.User

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_params = %{token: auth.credentials.token, email: auth.info.email, name: auth.info.nickname}
    changeset = User.changeset(%User{},user_params)
    sign_in(conn, changeset)
    
    # conn |> sign_in(changeset)
    
    # create plug to allow all parts of the app to identify the user
    
    # global state
    # demeter violations
    # being in a bootcamp
  end
  
  defp sign_in(conn, changeset) do
    case insert_or_update_user(changeset) do  
      {:ok, user} -> 
        conn
        |> put_flash(:info, "Welcome Back!")
        |> put_session(:user_id, user.id )
        |> redirect(to: topic_path(conn, :index))
      {:error, _reason} -> 
        conn
        |> put_flash(:error, "You suck")
        |> redirect(to: topic_path(conn, :index))
    end 
  end
  
  def logout(conn, _params) do
    conn 
    |> configure_session(drop: true) 
    |> put_flash(:info, "You been logged out homey")
    |> redirect(to: topic_path(conn, :index))
  end
  
  defp insert_or_update_user(changeset) do
     # could extract to a different method (insert_or_update_user)
    case Repo.get_by(User, email: changeset.changes.email) do
      nil -> Repo.insert(changeset)
      user -> {:ok, user}
    end
  end
end