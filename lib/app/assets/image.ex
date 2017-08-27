defmodule App.Assets.Image do
  use Ecto.Schema
  import Ecto.Changeset
  alias App.Assets.Image


  schema "images" do
    field :filename, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(%Image{} = image, attrs) do
    image
    |> cast(attrs, [:name, :filename])
    |> validate_required([:name, :filename])
  end
end
