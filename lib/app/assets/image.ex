defmodule App.Assets.Image do
  use Ecto.Schema
  import Ecto.Changeset
  alias App.Assets.Image

  # GB arc
  use Arc.Ecto.Schema


  schema "images" do

    # GB arc
    field :filename, App.ImageFile.Type
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(%Image{} = image, attrs) do
    image
    |> cast(attrs, [:name, :filename])
    # GB arc
    |> cast_attachments(attrs, [:filename])
    |> validate_required([:name, :filename])
  end
end
