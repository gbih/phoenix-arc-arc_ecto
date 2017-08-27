defmodule App.Repo.Migrations.CreateImages do
  use Ecto.Migration

  def change do
    create table(:images) do
      add :name, :string
      add :filename, :string

      timestamps()
    end

  end
end
