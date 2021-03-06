defmodule Discuss.User do
  use Discuss.Web, :model

  schema "users" do
    field :email, :string
    field :token, :string
    field :name, :string
    has_many :topics, Discuss.Topic
    has_many :comment, Discuss.Comment

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :token, :name])
    |> validate_required([:email, :token, :name])
  end
end
